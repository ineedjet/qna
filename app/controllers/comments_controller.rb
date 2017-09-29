class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_comment

  after_action :publish_comment, only: :create

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
