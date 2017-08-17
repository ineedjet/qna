class AnswersController < ApplicationController
  before_action :load_question, only: [:new]

  def new
    @answer = Answer.new(question: @question)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end
end
