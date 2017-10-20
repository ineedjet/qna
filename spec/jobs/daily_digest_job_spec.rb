require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:users) { create_list(:user, 2) }

  it 'send daily digest' do
    users.each do |user|
      expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original
    end
    DailyDigestJob.perform_now
  end
end
