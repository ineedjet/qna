class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :vote_rating
  has_many :comments
  has_many :attachments
end
