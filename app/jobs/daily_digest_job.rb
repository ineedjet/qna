class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    User.all.each do |user|
      DailyDigestMailer.digest(user).deliver_later
    end
  end
end
