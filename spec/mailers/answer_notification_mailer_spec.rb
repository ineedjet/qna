require "rails_helper"

RSpec.describe AnswerNotificationMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:mail) { AnswerNotificationMailer.notification(user, answer) }

  describe 'Daily Digest' do
    it 'renders the headers' do
      expect(mail.subject).to eq("New answer notification")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it 'contains question title' do
      expect(mail.body.encoded).to include(answer.question.title)
    end

    it 'contains answer body' do
      expect(mail.body.encoded).to include(answer.body)
    end
  end
end
