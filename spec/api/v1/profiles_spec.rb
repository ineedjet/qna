require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'return 401 status if no access_token' do
        get '/api/v1/profiles/me', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'return 401 status if access_token wrong' do
        get '/api/v1/profiles/me', params: { format: :json, access_token: '123456' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) {create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }

      it 'should return status 200' do
        expect(response).to be_success
      end

      %w(email id).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contains #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end

    end
  end

  describe 'GET index' do
    let!(:me) { create(:user) }
    let!(:access_token) {create(:access_token, resource_owner_id: me.id) }
    let!(:users) { create_list(:user, 2) }

    context 'unauthorized' do
      it 'return 401 status if no access_token' do
        get '/api/v1/profiles/', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'return 401 status if access_token wrong' do
        get '/api/v1/profiles/', params: { format: :json, access_token: '123456' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do

      before { get '/api/v1/profiles/', params: { format: :json, access_token: access_token.token } }

      it 'should return status 200' do
        expect(response).to be_success
      end

      it "does not contains me" do
        expect(response.body).to_not be_json_eql(me.to_json)
      end

      it "contains users" do
        users.each do |user|
          expect(response.body).to include_json(user.to_json)
        end
      end


    end

  end
end