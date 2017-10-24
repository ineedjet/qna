require 'rails_helper'

RSpec.describe User do
  it {should have_many(:questions).dependent(:destroy)}
  it {should have_many(:answers).dependent(:destroy)}
  it {should have_many(:authorizations).dependent(:destroy)}
  it {should have_many(:subscriptions).dependent(:destroy)}
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'user can use subscribes' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:subscribed_question) { create(:question) }
    let!(:subscription) { create(:subscription, user: user, question: subscribed_question ) }

    it 'user subscribe status for question' do
      expect(user).to_not be_subscribed_to(question)
      expect(user).to be_subscribed_to(subscribed_question)
    end

    it 'user can subscribe to question' do
      expect(user).to_not be_subscribed_to(question)
      expect{ user.subscribe_to(question) }.to change(Subscription, :count).by(1)
      expect(user).to be_subscribed_to(question)
    end

    it 'user can unsubscribe to question' do
      expect(user).to be_subscribed_to(subscribed_question)
      expect{ user.unsubscribe_to(subscribed_question) }.to change(Subscription, :count).by(-1)
      expect(user).to_not be_subscribed_to(subscribed_question)
    end
  end

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

        it 'create autorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'return user' do
          expect(User.find_for_oauth(auth)).to eq user
        end

      end
    end

    context 'user has not exist' do
      let(:auth){ OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@email.com' }) }

       it 'creates new user' do
         expect{ User.find_for_oauth(auth) }.to change(User, :count).by(1)
       end

       it 'return new user' do
         expect(User.find_for_oauth(auth)).to be_a(User)
       end

       it 'user use email'do
         user = User.find_for_oauth(auth)
         expect(user.email).to eq auth.info.email
       end

       it 'create autorization for user' do
         user = User.find_for_oauth(auth)
         expect(user.authorizations).to_not be_empty
       end

        it 'create autorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

    end
  end

  describe '.create_user_and_auth' do
    it 'creates new user' do
      expect{ User.create_user_and_auth('mail@example.com', 'twitter', '12345656') }.to change(User, :count).by(1)
    end

    it 'creates new autorization' do
      expect{ User.create_user_and_auth('mail@example.com', 'twitter',  '12345656') }.to change(Authorization, :count).by(1)
    end

    it 'user use email'do
      user = User.create_user_and_auth('mail@example.com', 'twitter', '12345656')
      expect(user.email).to eq 'mail@example.com'
    end

    it 'create autorization for User with provider and uid' do
      authorization = User.create_user_and_auth('mail@example.com', 'twitter', '12345656').authorizations.first

      expect(authorization.provider).to eq 'twitter'
      expect(authorization.uid).to eq '12345656'
    end
  end
end