class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:create]
  before_action :load_answer_and_question, only: [:destroy, :update, :set_best]
  after_action :publish_answer, only: :create

  respond_to :js

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
    respond_with @answer.update(answer_params) if current_user.author_of? @answer
  end

  def destroy
    respond_with(@answer.destroy) if current_user.author_of? @answer
  end

  def set_best
    respond_with(@answer.set_best) if current_user.author_of? @answer.question
  end

  private

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
        "question-#{@answer.question.id}", @answer.to_json(include: [:attachments, :user], methods: :vote_rating)
    )
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer_and_question
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end
