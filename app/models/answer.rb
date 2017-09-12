class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :body, presence: true

  def set_best
    self.transaction do
      self.question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end
end
