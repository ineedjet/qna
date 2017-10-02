class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: :show
  after_action :publish_question, only: :create

  respond_to :html

  def index
    respond_with(@questions = Question.all)
  end

  def show
    @answers = @question.answers
    @comment = Comment.new(commentable: @question)

    gon.question = @question
    gon.answers = @question.answers

    respond_with(@question)
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)

    flash[:notice] = 'Your question successfully created' if @question.save
    respond_with(@question)
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

  def build_answer
    @answer = Answer.new(question: @question)
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
        'questions', @question.to_json(include: [:attachments, :user], methods: :vote_rating)
    )
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
