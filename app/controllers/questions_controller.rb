class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  after_action :publish_question, only: :create

  def index
    @questions = Question.all

  end

  def show
    @answer = Answer.new(question: @question)
    @answer.attachments.build
    @answers = @question.answers

    @comment = Comment.new(commentable: @question)

    gon.question = @question
    gon.answers = @question.answers
  end

  def new
    @question = Question.new
    @question.attachments.build
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
