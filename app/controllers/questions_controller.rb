class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new(question: @question)
    @answers = @question.answers
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      flash[:notice] = 'Your question successfully created'
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if current_user.author_of? @question
      flash[:notice] = 'Your question successfully updated'
      @question.update(question_params)
    end
  end

  def destroy
    if current_user.author_of? @question
      flash[:notice] = 'Your question successfully deleted'
      @question.destroy
    end

    redirect_to questions_path
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
