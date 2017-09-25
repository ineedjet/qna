module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
    accepts_nested_attributes_for :votes, reject_if: :all_blank
  end

  def vote!(user, vote_type)
    self.votes.create!(user: user, vote_type: vote_type)
  end

  def vote_by(user)
    self.votes.where(user: user).first
  end

  def can_vote?(user)
    !self.vote_by(user) && self.user != user
  end

  def vote_delete!(user)
    self.votes.where(user: user).destroy_all
  end

  def vote_rating
    self.votes.where(vote_type: :positive).count - self.votes.where(vote_type: :negative).count
  end
end