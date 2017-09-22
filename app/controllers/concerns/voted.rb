module Voted
  extend ActiveSupport::Concern

  included do
    respond_to :json, only: [:vote_positive, :vote_negative, :vote_del]
    before_action :load_votable, only: [:vote_positive, :vote_negative, :vote_del]
  end

  def vote_positive
    unless current_user.author_of?(@votable)
      unless @votable.vote_by(current_user)
        @votable.vote!(current_user, 'positive')
      end
    end
  end

  def vote_negative
    unless current_user.author_of?(@votable)
      unless @votable.vote_by(current_user)
        @votable.vote!(current_user, 'negative')
      end
    end
  end

  def vote_del
    if @votable.vote_by(current_user)
      @votable.vote_delete!(current_user)
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def load_votable
    @votable = model_klass.find(params[:id])
  end
end