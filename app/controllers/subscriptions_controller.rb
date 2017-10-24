class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create, :destroy]

  authorize_resource

  respond_to :json

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
