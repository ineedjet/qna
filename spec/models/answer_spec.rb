require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }

  it { should have_many(:attachments).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  it_behaves_like 'votable' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:votable) { create(:answer, question: question, user: user) }
  end

  it_behaves_like 'commentable'

  context 'set best' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:answer2) { create(:answer, question: question, user: user) }
    let!(:answer3) { create(:answer, question: question, user: user) }
    before { answer.set_best }

    it 'answer is best if it set' do
      expect(answer.best?).to eq true
    end

    it 'answer is not best if set another answer' do
      answer2.set_best
      answer.reload
      expect(answer.best?).to eq false
    end

    it 'should be correctly ordered if best not set' do
      expect(question.answers.first).to eq answer
    end

    it 'should be correctly ordered if best is set' do
      answer2.set_best
      expect(question.answers.first).to eq answer2
      expect(question.answers.second).to eq answer
      expect(question.answers.last).to eq answer3
    end
  end

  context 'send answer to question subscribers' do
    let(:question) { create(:question) }
    let(:answer) { build(:answer, question: question) }

    it 'send answer to AnswerNotificationJob after create' do
      expect(AnswerNotificationJob).to receive(:perform_later).with(answer)

      answer.save
    end
  end

end
