class Answer < ApplicationRecord
  belongs_to :question, optional: true
  validates :body, presence: true
end
