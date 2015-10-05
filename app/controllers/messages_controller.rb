class MessagesController < ApplicationController
  before_filter :authenticate_user!

  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.build(:body => params[:message][:body])
    @message.user_id = current_user.id
    @message.save!

    @path = conversation_path(@conversation)
  end
end
