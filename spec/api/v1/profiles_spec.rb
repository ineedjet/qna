require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    let(:me) {create(:user)}
    let(:access_token) {create(:access_token, resource_owner_id: me.id)}

    it_behaves_like 'API authenticable'
    it_behaves_like 'API successfuble'

    before {do_request(access_token: access_token.token)}

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

    def do_request(options = {})
      get '/api/v1/profiles/me', params: {format: :json}.merge(options)
    end
  end

  describe 'GET index' do
    let!(:me) {create(:user)}
    let!(:access_token) {create(:access_token, resource_owner_id: me.id)}
    let!(:users) {create_list(:user, 2)}

    it_behaves_like 'API authenticable'
    it_behaves_like 'API successfuble'

    before {do_request(access_token: access_token.token)}

    it "does not contains me" do
      expect(response.body).to_not be_json_eql(me.to_json)
    end

    it "contains users" do
      users.each do |user|
        expect(response.body).to include_json(user.to_json)
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/', params: {format: :json}.merge(options)
    end
  end
end