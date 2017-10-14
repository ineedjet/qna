require 'rails_helper'

describe 'Profile API' do
  describe 'GET /index' do
    let!(:question) { create(:question) }

    context 'unauthorized' do
      it 'return 401 status if no access_token' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'return 401 status if access_token wrong' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: '123456' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) {create(:access_token) }

      context '/index' do
        let!(:answers) { create_list(:answer, 3, question: question) }

        before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

        it 'should return status 200' do
          expect(response).to be_success
        end

        it 'return list of answer for question' do
          expect(response.body).to have_json_size(3)
        end

        %w(id body created_at updated_at).each do |attr|
          it "answer object contains #{attr}" do
            answer = answers.first
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
          end
        end
      end



    end

  end

end