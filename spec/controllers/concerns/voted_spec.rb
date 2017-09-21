require 'rails_helper'

shared_examples "voted" do
  let(:model) { described_class.controller_name.classify }

  describe 'POST #vote' do
    let!(:votable) { create(model.underscore.to_sym, user: user) }

    context "Not votable's author vote positive" do
      sign_in_user

      it 'saves the new vote in the database' do
        expect { post :vote_positive, params: { id: votable }, format: :json }.to change(votable, :vote_rating).by(1)
      end

      it 'renders create_voted vote' do
        # post :vote, params: { id: votable, vote_type: 'positive' }, format: :json
        # expect(JSON.parse(response.body)['vote']['id']).to eq Vote.first.id
      end
    end

    context "Not votable's author vote negative" do
      sign_in_user

      it 'saves the new vote in the database' do
        expect { post :vote_negative, params: { id: votable }, format: :json }.to change(votable, :vote_rating).by(-1)
      end

      it 'renders create_voted vote' do
        # post :vote, params: { id: votable, vote_type: 'positive' }, format: :json
        # expect(JSON.parse(response.body)['vote']['id']).to eq Vote.first.id
      end
    end

    context "Votable's author" do
      sign_in_user
      before{ votable.user = @user }


      it 'not saves the new vote in the database' do
        expect { post :vote_positive, params: { id: votable }, format: :json }.to_not change(votable, :vote_rating)
      end

      it 'renders error' do
        # post :vote, params: { id: votable, vote_type: 'positive' }, format: :json
        # expect(JSON.parse(response.body)['error']).to eq "Author can't vote his question or answer."
      end
    end

    context "Anonimous voter" do
      it 'not saves the new vote in the database' do
        expect { post :vote_positive, params: { id: votable }, format: :json }.to_not change(votable, :vote_rating)
      end

      it 'renders error' do
        # post :vote, params: { id: votable, vote_type: 'positive' }, format: :json
        # expect(JSON.parse(response.body)['error']).to eq "Author can't vote his question or answer."
      end
    end
  end

  describe 'POST #vote_del' do
    let(:user) { create(:user) }
    let(:voted_user) { create(:user) }
    let!(:votable) { create(model.underscore.to_sym, user: user) }
    let!(:vote) { create(:vote, user: voted_user, votable: votable, vote_type: 'positive') }

    context 'user is the author of the vote' do
      sign_in_user
      before{ vote.user = @user }

      it 'deletes the vote' do
        expect { post :vote_del, params: { id: votable }, format: :json }.to change(votable, :vote_rating).by(-1)
      end

      it 'renders deleted vote' do
        #id = vote.id
        #post :vote_del, params: { id: votable }, format: :json
        # expect(JSON.parse(response.body)['vote']['id']).to eq id
      end
    end

    context 'user is not the author of the vote' do
      sign_in_user

      it 'not deletes the vote' do
        expect { post :vote_del, params: { id: votable }, format: :json }.to_not change(votable, :vote_rating)
      end

      it 'renders error' do
        # post :vote_del, params: { id: votable }, format: :json
        # expect(JSON.parse(response.body)['error']).to eq "Only the author of the vote can delete it."
      end
    end
  end
end