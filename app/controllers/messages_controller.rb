# frozen_string_literal: true

# Controller 2 of 2 used by mailbox. Used to create new messages in a conversation.
class MessagesController < ApplicationController
  before_action :authenticate_user!

  def new
    @chosen_recipient = User.find_by(id: params[:to].to_i) if params[:to]
  end

  def create
    conversation = current_user.send_message(User.where(id: params['recipients']),
                                             params[:message][:body],
                                             params[:message][:subject]).conversation
    flash[:success] = 'Message has been sent!'
    redirect_to conversation_path(conversation)
  end
end
