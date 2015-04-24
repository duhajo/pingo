class ConversationsController < ApplicationController
  before_filter :authenticate_user!

  layout false

  def create
    if params[:job_id].nil?
      if Conversation.between(params[:sender_id],params[:recipient_id]).present?
        @conversation = Conversation.between(params[:sender_id],params[:recipient_id]).first
      else
        @conversation = Conversation.create!(:sender_id => params[:sender_id], :recipient_id => params[:recipient_id])
      end
      render json: { conversation_id: @conversation.id }
    else
      if Conversation.between(params[:sender_id],params[:recipient_id],params[:job_id]).present?
        @conversation = Conversation.between(params[:sender_id],params[:recipient_id],params[:job_id]).first
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
    @messages = @conversation.messages
    @message = Message.new
  end

  def interlocutor(conversation)
    current_user == conversation.recipient ? conversation.sender : conversation.recipient
  end
end