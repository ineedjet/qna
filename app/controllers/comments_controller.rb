class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_comment, only: [:update, :destroy]
  before_action :load_commentable, only: [:create]

  after_action :publish_comment, only: :create

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      flash[:notice] = 'Your comment successfully created'
    else
      flash[:notice] = 'Your comment has a problem'
    end

    render 'comments/create'
  end

  def update
    if current_user.author_of? @comment
      flash[:notice] = 'Your comment successfully updated'
      @comment.update(comment_params)
    end
  end

  def destroy
    if current_user.author_of? @comment
      flash[:notice] = 'Your comment successfully deleted'
      @comment.destroy
    end
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
    #return if @answer.errors.any?
    #ActionCable.server.broadcast(
    #    "question-#{@answer.question.id}", @answer.to_json(include: [:attachments, :user], methods: :vote_rating)
    #)
  end

  def load_comment
    @comment = Comment.find(params[:id])
  end


  def comment_params
    params.require(:comment).permit(:body)
  end
end
