require 'rails_helper'

RSpec.describe AnswerNotificationJob, type: :job do
  let!(:question) { create(:question) }
  let!(:subscribered_user) { create(:user) }
  let!(:unsubscribered_user) { create(:user) }
  let!(:subscription) { create(:subscription, question: question, user: subscribered_user)}
  let!(:answer) {create(:answer, question: question)}

  it 'send answer notification for subscribered user' do
    expect(AnswerNotificationMailer).to receive(:notification).with(subscribered_user, answer).and_call_original
    AnswerNotificationJob.perform_now(answer)
  end

  # test for unsubscribered_user

  #it 'do not send answer notification for unsubscribered users' do
  #  expect(AnswerNotificationMailer).to_not receive(:notification).with(unsubscribered_user, answer).and_call_original
  #  AnswerNotificationJob.perform_now(answer)
  #end
end
