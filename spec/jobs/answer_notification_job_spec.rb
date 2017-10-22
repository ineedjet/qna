require 'rails_helper'

RSpec.describe AnswerNotificationJob, type: :job do
  let!(:subscribered_user) { create(:user) }
  let!(:question) { create(:question, user: subscribered_user) }
  let!(:unsubscribered_user) { create(:user) }
  let!(:answer) {create(:answer, question: question)}

  it 'send answer notification for subscribered user' do
    expect(AnswerNotificationMailer).to receive(:notification).with(subscribered_user, answer).and_call_original
    AnswerNotificationJob.perform_now(answer)
  end

end
