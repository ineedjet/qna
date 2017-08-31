class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      flash[:notice] = 'Your answer successfully created'
      redirect_to @question
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author_of? @answer
      flash[:notice] = 'Your answer successfully deleted'
      @answer.destroy
    end

    redirect_to question_path
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
