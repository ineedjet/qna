class Api::V1::AnswersController < Api::V1::BaseController

  def index
    respond_with Question.find(params[:question_id]).answers
  end

  def show
    respond_with Answer.find(params[:id])
  end

end
