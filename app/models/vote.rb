class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  enum vote_type: { positive: 1, negative: -1 }
end
