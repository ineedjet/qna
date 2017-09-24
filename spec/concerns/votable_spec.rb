require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }
  it { should accept_nested_attributes_for :votes }

  context 'methods' do
    let(:model) { described_class }
    let(:user) { create(:user) }
    let(:voted_user) { create(:user) }
    let!(:votable) { create(model.to_s.underscore.to_sym, user: user) }
    let!(:vote) { create(:vote, votable: votable, vote_type: 'positive', user: voted_user) }
    let(:stranger_user) { create(:user) }

    it '#vote_by' do
      expect(votable.vote_by(voted_user)).to eq vote
    end

    it '#vote!' do
      expect { votable.vote!(user, 'positive') }.to change { Vote.count }.by(1)
    end

    it '#vote_delete!' do
      expect { votable.vote_delete!(voted_user) }.to change { Vote.count }.by(-1)
    end

    it '#vote_rating' do
      expect(votable.vote_rating).to eq 1
    end

    it 'change rating +1 if vote positive' do
      expect { votable.vote!(user, 'positive') }.to change { votable.vote_rating }.by(1)
    end

    it 'change rating -1 if vote negative' do
      expect { votable.vote!(user, 'negative') }.to change { votable.vote_rating }.by(-1)
    end

    it 'change rating -1 if positive vote deleted' do
      expect { votable.vote_delete!(voted_user) }.to change { votable.vote_rating }.by(-1)
    end

    it 'can_vote?(user)' do
      expect(votable.can_vote?(user)).to be false
      expect(votable.can_vote?(voted_user)).to be false
      expect(votable.can_vote?(stranger_user)).to be true
    end

  end
end