require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:user) { create(:user) }

  it 'send daily digest' do
    expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original
    DailyDigestJob.perform_now
  end
end
