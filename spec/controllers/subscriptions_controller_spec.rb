require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:question2) { create(:question, user: user2) }

  describe 'patch #subscribe' do
    context "Not subscribered user subscribe" do
      sign_in_user

      it 'saves the new subscribe in the database' do
        expect { post :create, params: { question_id: question.id }, format: :json }.to change(question.subscriptions, :count ).by(1)
        expect(JSON.parse(response.body)['subscription_status']).to be_truthy
      end
    end
  end

  describe 'patch #unsubscribe' do
    let!(:subscription) { create(:subscription, user: user, question: question2 ) }

    context "Subscribered user unsubscribe" do
      before{ sign_in_the_user(user) }

      it 'femove subscribe from the database' do
        expect { delete :destroy, params: { question_id: question.id }, format: :json }.to change(question.subscriptions, :count ).by(-1)
        expect(JSON.parse(response.body)['subscription_status']).to be_falsey
      end
    end
  end
end
