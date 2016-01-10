class PinsController < ApplicationController

  before_filter :authenticate_user!, :only => :new
  protect_from_forgery :except => :index
  uploads_nicedit_image :upload_action_name

  autocomplete :pin, :title, :full => true

  # GET /pins
  # GET /pins.json
  def index
    if params[:pin_id]
      @pin = Pin.find(params[:pin_id])
      redirect_to @pin
    elsif params[:scope]
      if params[:scope] == "categories"
        @categories = Pin.where('parent_id' => nil, 'type' => 0)
        @unsorted_pin_tags = Pin.where(type: [1,2], parent_id: nil).skill_counts.order('count desc').limit(5)
        respond_to do |format|
          format.html {
            render :partial => 'categories_overview', :categories => @categories, :unsorted_pin_tags => @unsorted_pin_tags
          }
        end
      elsif params[:scope] == "unsorted"
        @supplies = Pin.where(type: 1, parent_id: nil).joins(:user).select("pins.*, users.email as user_email, users.name as user_name, users.id as user_id")
        @demands = Pin.where(type: 2, parent_id: nil).joins(:user).select("pins.*, users.email as user_email, users.name as user_name, users.id as user_id")
        @most_used_tags = Pin.where(type: [1,2], parent_id: nil).skill_counts.order('count desc').limit(15)

        if params[:pins_filter].present?
          @supplies = @supplies.where('lower(title) LIKE ?', "%#{params[:pins_filter].downcase}%")
          @demands = @demands.where('lower(title) LIKE ?', "%#{params[:pins_filter].downcase}%")
        end

        respond_to do |format|
          format.html {
            render 'unsorted_pins.erb', :demands => @demands, :supplies => @supplies, :most_used_tags => @most_used_tags
          }
        end
      else
        @supplies = Pin.where(type: 1).joins(:user).select("pins.*, users.email as user_email, users.name as user_name, users.id as user_id")
        @demands = Pin.where(type: 2).joins(:user).select("pins.*, users.email as user_email, users.name as user_name, users.id as user_id")

        if params[:pins_filter].present?
          @supplies = @supplies.where('lower(title) LIKE ?', "%#{params[:pins_filter].downcase}%")
          @demands = @demands.where('lower(title) LIKE ?', "%#{params[:pins_filter].downcase}%")
        end

        respond_to do |format|
          format.html {
            render :partial => 'pins_overview', :supplies => @supplies, :demands => @demands
          }
        end
      end
    else
      @categories = Pin.where('parent_id' => nil, 'type' => 0)
      @unsorted_pin_tags = Pin.where(type: [1,2], parent_id: nil).skill_counts.order('count desc').limit(5)
    end
  end

  def get_conversations(pin)
    if current_user
      if @is_manager
        return Conversation.pin_involving(current_user, pin) #ToDo
      else
        return Conversation.pin_involving(current_user, pin)
      end
    else
      return nil
    end
  end

  # GET /pins/1
  # GET /pins/1.json
  def show
    @pin = Pin.find(params[:id])

    @is_manager = Pin.is_creator_of_pin(@pin, current_user)
    @manager = User.find(@pin.user_id)

    if @pin.parent_id
      @parent_pins = @pin.ancestors
    end

    @all_pins = Pin.where('parent_id' => @pin.id)

    if @pin.type == 0
      @most_used_tags = @all_pins.skill_counts
      @categories = @all_pins.where('type' => 0)
      @supplies = @all_pins.where(type: 1).joins(:user).select("pins.*, users.email as user_email, users.name as user_name, users.id as user_id")
      @demands = @all_pins.where(type: 2).joins(:user).select("pins.*, users.email as user_email, users.name as user_name, users.id as user_id")
      if params[:pins_filter].present?
        @supplies = @supplies.where('lower(title) LIKE ?', "%#{params[:pins_filter].downcase}%")
        @demands = @demands.where('lower(title) LIKE ?', "%#{params[:pins_filter].downcase}%")
      end
    else
      @pin_ids = Array.new << @pin.id
      @all_pins.each do |pin|
        @pin_ids << pin.id
      end

      @conversations = get_conversations(@pin.id)
      @pin_chat_active = true

      @pin_files = PinsFiles.find_all_by_pin_id(@pin.id)

      @file_others , @file_images = [], []
      @pin_files.each do |attachment|
        @file_images << attachment if ((attachment.file.content_type || "").split("/").first == 'image')
        @file_others << attachment if ((attachment.file.content_type || "").split("/").first != 'image')
      end
    end
    respond_to do |format|
      format.html # show.html.erb.erb
      format.json { render json: @pin }
    end
  end

  # GET /pins/new
  # GET /pins/new.json
  def new
    if params[:id]
       @parent_pin = Pin.find(params[:id])
    end

    if params[:type].present?
      @type = 0 if params[:type] == 'category'
      @type = 1 if params[:type] == 'supply'
      @type = 2 if params[:type] == 'demand'
    else
      @type = false
    end

    @pin = Pin.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pin }
    end
  end

  # GET /pins/new
  # GET /pins/new.json
  def new_file
    @pin = Pin.find(params[:id])
    @pin_file = PinsFiles.new(params[:pins_files])
    @pin_file.user_id = current_user.id
    @pin_file.pin_id = @pin.id

    respond_to do |format|
      if @pin_file.save
        format.html { redirect_to @pin, notice: 'File was uploaded successfully.' }
        format.json { render json: @pin, status: :created, location: @pin }
      end
    end
  end

  def child
    render :create
  end

  # GET /pins/1/edit
  def edit
    @pin = Pin.find(params[:id])
    @is_manager = Pin.is_creator_of_pin(@pin, current_user)

    if @pin.type == 0
      @type = 0
    elsif @pin.type == 1 || @pin.type == 2
      @type = 2
    else
      @type = 1
    end
  end

  # POST /pins
  # POST /pins.json
  def create
    @pin = Pin.new(params[:pin])
    @pin.user_id = current_user.id

    respond_to do |format|
      if @pin.save
        @pin.reload
        #ToDo: Add Type Distinction ("add Resource ABC to category XYZ")
        format.html { redirect_to @pin, notice: 'pin was successfully created.' }
        format.json { render json: @pin, status: :created, location: @pin }
      else
        format.html { render action: "new" }
        format.json { render json: @pin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pins/1
  # PUT /pins/1.json
  def update
    @pin = Pin.find(params[:id])
    respond_to do |format|
      if @pin.update_attributes(params[:pin].except(:user_list, :manager_ids))
        format.html { redirect_to @pin, notice: 'pin was successfully updated.'}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pins/1
  # DELETE /pins/1.json
  def destroy
    @pin = Pin.find(params[:id])
    @pin.destroy

    respond_to do |format|
      format.html { redirect_to pins_url }
      format.json { head :no_content }
    end
  end

  def get_tags
    @pin = Pin.find(params[:id])
    @tags = @pin.tag_counts_on(:skills, :limit => 5, :order => "count desc")
  end

  def set_status
    @pin = Pin.find(params[:id])
    @is_manager = Pin.is_creator_of_pin(@pin, current_user)
    if @is_manager
      @pin.status = params[:status]
      @pin.save()
    end

    respond_to do |format|
      format.html {
        render :partial => 'status', :pin => @pin, :is_manager => @is_manager
      }
      format.json { head :no_content }
      format.js {}
    end
  end

  def map_for_pin
    @pin = Pin.find(params[:id])
    @lat = @pin.latitude
    @long = @pin.longitude
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { render :action => 'map', :pin => @pin }
    end
  end
end
