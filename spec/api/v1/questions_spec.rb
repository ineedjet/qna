require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'return 401 status if no access_token' do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'return 401 status if access_token wrong' do
        get '/api/v1/questions', params: { format: :json, access_token: '123456' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) {create(:access_token) }

      context '/index' do
        let!(:questions) { create_list(:question, 3) }

        before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

        it 'should return status 200' do
          expect(response).to be_success
        end

        it 'return list of questions' do
          expect(response.body).to have_json_size(3)
        end

        %w(id title body created_at updated_at).each do |attr|
          it "question object contains #{attr}" do
            question = questions.first
            expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr).at_path("0/#{attr}")
          end
        end
      end

      context '/show' do
        let!(:question) { create(:question) }
        let!(:comment) { create(:comment, commentable: question) }

        before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

        %w(id title body created_at updated_at).each do |attr|
          it "question object contains #{attr}" do
            expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr)
          end
        end

        it 'comments includes in question object' do
          expect(response.body).to have_json_size(1).at_path('comments')
        end

        %w(id body created_at updated_at).each do |attr|
          it "question contains comments #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path(attr).at_path("comments/0/#{attr}")
          end
        end

      end

    end
  end

end