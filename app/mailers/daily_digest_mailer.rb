class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where('created_at > ?', (Time.now - 24.hours))
    mail(to: user.email, subject: 'Daily Digest')
  end
end
