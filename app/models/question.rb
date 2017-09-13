class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy
  validates :title, :body, presence: true
end
