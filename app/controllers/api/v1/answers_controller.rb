class Api::V1::AnswersController < Api::V1::BaseController

  def index
    respond_with Question.find(params[:question_id]).answers.to_json
  end

  def show
    respond_with Answer.find(params[:id])
  end

  def create
    respond_with @answer = Answer.create(answer_params.merge(question_id: params[:question_id]).merge(user_id: current_resource_owner.id))
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
