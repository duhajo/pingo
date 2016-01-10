class ConversationsController < ApplicationController
  before_filter :authenticate_user!

  layout false

  def create
    if params[:pin_id].nil?
      @conversation = Conversation.between(params[:sender_id],params[:recipient_id])
      if @conversation.present?
        @conversation = @conversation.first
      else
        @conversation = Conversation.create!(:sender_id => params[:sender_id], :recipient_id => params[:recipient_id])
      end
      render json: { conversation_id: @conversation.id }
    else
      @conversation = Conversation.between_pin(params[:sender_id],params[:recipient_id],params[:pin_id])
      if @conversation.present?
        @conversation = @conversation.first
      else
        @conversation = Conversation.create!(:sender_id => params[:sender_id], :recipient_id => params[:recipient_id], :pin_id => params[:pin_id])
      end
      render json: { pin_id: params[:pin_id], conversation_id: @conversation.id }
    end
  end

  def show
    @conversation = Conversation.find(params[:id])
    @reciever = interlocutor(@conversation)
    @messages = @conversation.messages
    @message = Message.new
  end

  def show_pin_conversation
    @conversation = Conversation.find(params[:c_id])
    @pin = Pin.find(params[:pin_id])
    @reciever = interlocutor(@conversation)
    @is_owner = current_user.id == @conversation.recipient.id ? true : false
    @messages = @conversation.messages.reverse!
    @message = Message.new
  end

  def interlocutor(conversation)
    current_user == conversation.recipient ? conversation.sender : conversation.recipient
  end
end
