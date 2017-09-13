class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :body, presence: true

  default_scope { order(best: :desc, created_at: :asc) }

  def set_best
    self.transaction do
      self.question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end
end
