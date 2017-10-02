class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_comment, only: [:update, :destroy]
  before_action :load_commentable, only: [:create]

  after_action :publish_comment, only: :create

  respond_to :js

  def create
    respond_with(@comment = @commentable.comments.create(comment_params))
  end

  def update
    respond_with(@comment.update(comment_params)) if current_user.author_of? @comment
  end

  def destroy
    respond_with(@comment.destroy) if current_user.author_of? @comment
  end


  private

  def load_commentable
    @commentable = commentable_name.classify.constantize.find(params[commentable_id])
  end

  def commentable_name
    params[:commentable]
  end

  def commentable_id
    (commentable_name.classify.downcase + '_id').to_sym
  end

  def publish_comment
    return if @comment.errors.any?

    if @comment.commentable_type == "Question"
      question_id =  @comment.commentable.id
    else
      question_id =  @comment.commentable.question.id
    end

    ActionCable.server.broadcast( "comments-for-question-#{question_id}", @comment.to_json )
  end

  def load_comment
    @comment = Comment.find(params[:id])
  end


  def comment_params
    params.require(:comment).permit(:body).merge(user_id: current_user.id)
  end
end
