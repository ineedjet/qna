class AnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.all.each do |subscription|
      AnswerNotificationMailer.notification(subscription.user, answer).deliver_later
    end
  end
end
