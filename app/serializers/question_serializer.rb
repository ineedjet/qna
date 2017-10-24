class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :vote_rating, :subscription_status
  has_many :comments
  has_many :attachments

  def subscription_status
    current_user&.subscribed_to?(object)
  end
end
