require 'rails_helper'

shared_examples "voted" do
  let(:model) { described_class.controller_name.classify }

  describe 'POST #vote' do
    let!(:user) { create(:user) }
    let!(:votable) { create(model.underscore.to_sym, user: user) }

    context "Not votable's author vote positive" do
      sign_in_user

      it 'saves the new vote in the database' do
        expect { post :vote_positive, params: { id: votable }, format: :json }.to change(votable, :vote_rating).by(1)
      end

    end

    context "Not votable's author vote negative" do
      sign_in_user

      it 'saves the new vote in the database' do
        expect { post :vote_negative, params: { id: votable }, format: :json }.to change(votable, :vote_rating).by(-1)
      end

    end

    context "Not votable's author vote positive again" do
      let(:voted_user) { create(:user) }
      let!(:vote) { create(:vote, user: voted_user, votable: votable, vote_type: 'positive') }

      it 'do not saves the new vote in the database' do
        sign_in_the_user(voted_user)
        expect { post :vote_negative, params: { id: votable }, format: :json }.to_not change(votable, :vote_rating)
      end

    end

    context "Votable's author" do
      it 'not saves the new vote in the database' do
        sign_in_the_user(user)
        expect { post :vote_positive, params: { id: votable }, format: :json }.to_not change(votable, :vote_rating)
      end

    end

    context "Anonimous voter" do
      it 'not saves the new vote in the database' do
        expect { post :vote_positive, params: { id: votable }, format: :json }.to_not change(votable, :vote_rating)
      end

    end
  end

  describe 'POST #vote_del' do
    let(:user) { create(:user) }
    let(:voted_user) { create(:user) }
    let!(:votable) { create(model.underscore.to_sym, user: user) }
    let!(:vote) { create(:vote, user: voted_user, votable: votable, vote_type: 'positive') }

    context 'user is the author of the vote' do
      it 'deletes the vote' do
        sign_in_the_user(voted_user)
        expect { post :vote_del, params: { id: votable }, format: :json }.to change(votable, :vote_rating).by(-1)
      end

    end

    context 'user is not the author of the vote' do
      sign_in_user

      it 'not deletes the vote' do
        expect { post :vote_del, params: { id: votable }, format: :json }.to_not change(votable, :vote_rating)
      end

    end
  end
end