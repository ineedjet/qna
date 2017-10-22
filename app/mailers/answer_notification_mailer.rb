class AnswerNotificationMailer < ApplicationMailer
  def notification(user, answer)
    @answer = answer
    mail(to: user.email, subject: 'New answer notification')
  end
end
