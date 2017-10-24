require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:mail) { DailyDigestMailer.digest(user) }
  let!(:questions) { create_list(:question, 2) }
  let!(:old_question) { create(:question, created_at: 2.days.ago, updated_at: 2.days.ago) }

  describe 'Daily Digest' do
    it 'renders the headers' do
      expect(mail.subject).to eq("Daily Digest")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it 'contains fresh questions' do
      questions.each do |question|
        expect(mail.body.encoded).to include(question.title)
      end
    end

    it 'did not contains old questions' do
      expect(mail.body.encoded).to_not include(old_question.title)
    end
  end
end
