class SubscriptionsController < ApplicationController
  before_action :load_question, only: [:create, :destroy]
  respond_to :json

  skip_authorization_check

  def create
    current_user.subscribe_to(@question)
    respond_with(@question)
  end

  def destroy
    current_user.unsubscribe_to(@question)
    render json: @question
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end
end
