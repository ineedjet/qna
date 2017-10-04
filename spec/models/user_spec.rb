require 'rails_helper'

RSpec.describe User do
  it {should have_many(:questions).dependent(:destroy)}
  it {should have_many(:answers).dependent(:destroy)}
  it {should have_many(:authorizations).dependent(:destroy)}
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  context 'check author_of?' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'user is author' do
      expect(user).to be_author_of(question)
    end

    it 'user is not author' do
      expect(user2).to_not be_author_of(question)
    end
  end

  describe '.find_for_oauth' do
    let!(:user){ create(:user ) }
    let(:auth){ OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user alredy has autorization' do
      it 'returne the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not autorization' do
      context 'user exist' do
        let(:auth){ OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

        it 'does not create new user' do
          expect{ User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'create autorization for user' do
          expect{ User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'create autorization with provider and id' do
          user = User.find_for_oauth(auth)
          authorization = user.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'return user' do
          expect(User.find_for_oauth(auth)).to eq user
        end

      end
    end
  end
end