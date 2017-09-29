module Commented
  extend ActiveSupport::Concern

  included do
    respond_to :json, only: [:comment]
    before_action :load_commentable, only: [:comment]
  end

  def comment
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      flash[:notice] = 'Your comment successfully created'
    else
      flash[:notice] = 'Your comment has a problem'
    end

    render 'comments/create'
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def load_commentable
    @commentable = model_klass.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end