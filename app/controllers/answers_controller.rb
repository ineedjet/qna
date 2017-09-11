class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:create, :destroy, :update]
  before_action :load_answer, only: [:destroy, :update]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      flash[:notice] = 'Your answer successfully created'
    else
      flash[:notice] = 'Your answer has a problem'
    end
  end

  def update
    if current_user.author_of? @answer
      flash[:notice] = 'Your answer successfully updated'
      @answer.update(answer_params)
    end
  end

  def destroy
    if current_user.author_of? @answer
      flash[:notice] = 'Your answer successfully deleted'
      @answer.destroy
    end

    redirect_to question_path @question
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
