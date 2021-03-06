require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should accept_nested_attributes_for :attachments }

  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  context 'subscribe author to his question' do
    let(:user) { create(:user) }
    let(:question) { build(:question, user: user) }

    it 'send answer to AnswerNotificationJob after create' do
      expect(user).to receive(:subscribe_to).with(question)
      question.save
    end
  end
end
