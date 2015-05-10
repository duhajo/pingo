class ConversationsController < ApplicationController
  before_filter :authenticate_user!

  layout false

  def create
    if params[:job_id].nil?
      @conversation = Conversation.between(params[:sender_id],params[:recipient_id])
      if @conversation.present?
        @conversation = @conversation.first
      else
        @conversation = Conversation.create!(:sender_id => params[:sender_id], :recipient_id => params[:recipient_id])
      end
      render json: { conversation_id: @conversation.id }
    else
      @conversation = Conversation.between_job(params[:sender_id],params[:recipient_id],params[:job_id])
      if @conversation.present?
        @conversation = @conversation.first
      else
        @conversation = Conversation.create!(:sender_id => params[:sender_id], :recipient_id => params[:recipient_id], :job_id => params[:job_id])
      end
      render json: { job_id: params[:job_id], conversation_id: @conversation.id }
    end
  end

  def show
    @conversation = Conversation.find(params[:id])
    @reciever = interlocutor(@conversation)
    @messages = @conversation.messages
    @message = Message.new
  end

  def show_job_conversation
    @conversation = Conversation.find(params[:c_id])
    @job = Job.find(params[:job_id])
    @reciever = interlocutor(@conversation)
    @is_owner = current_user.id == @conversation.recipient.id ? true : false
    @messages = @conversation.messages.reverse!
    @message = Message.new
  end

  def interlocutor(conversation)
    current_user == conversation.recipient ? conversation.sender : conversation.recipient
  end
end