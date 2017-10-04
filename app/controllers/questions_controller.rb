class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, :gon_question, only: :show
  after_action :publish_question, only: :create

  respond_to :js, only: :update

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with(@question)
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def create
     respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    respond_with @question.update(question_params) if current_user.author_of? @question
  end

  def destroy
    respond_with(@question.destroy) if current_user.author_of? @question
  end

  private

  def gon_question
    gon.question = @question
    gon.answers = @question.answers
  end

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
