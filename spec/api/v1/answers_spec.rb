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
      let(:user) { create(:user) }
      let(:access_token) {create(:access_token, resource_owner_id: user.id) }

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

      context '/show' do
        let!(:question) { create(:question) }
        let!(:answer) { create(:answer, question: question) }
        let!(:comment) { create(:comment, commentable: answer) }
        let!(:answer_attachment) { create :attachment, attachable: answer }

        before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

        %w(id body created_at updated_at).each do |attr|
          it "answer object contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr)
          end
        end

        it 'comments includes in answer object' do
          expect(response.body).to have_json_size(1).at_path('comments')
        end

        %w(id body created_at updated_at).each do |attr|
          it "answer contains comments #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path(attr).at_path("comments/0/#{attr}")
          end
        end

        it 'attachments includes in answer object' do
          expect(response.body).to have_json_size(1).at_path('attachments')
        end

        %w(id created_at updated_at).each do |attr|
          it "answer contains attachments #{attr}" do
            expect(response.body).to be_json_eql(answer_attachment.send(attr.to_sym).to_json).at_path("attachments/0/#{attr}")
          end
        end

        it "answer contains attachments filename" do
          expect(response.body).to be_json_eql(answer_attachment.file.file.filename.to_json).at_path("attachments/0/filename")
        end

        it "answer contains attachments url" do
          expect(response.body).to be_json_eql(answer_attachment.file.url.to_json).at_path("attachments/0/url")
        end

      end


      context '/create' do

        context 'with valid attributes' do

          it 'saves the new answer in the database' do
            expect{
              post "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token, answer: { body: 'Answer body' } }
            }.to change(Answer, :count).by(1)
          end

          it 'return the new answer' do
            post "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token, answer: { body: 'Answer body' } }
            expect(response.body).to be_json_eql('Answer body'.to_json).at_path('body')
          end

          it 'check user is author' do
            post "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token, answer: { body: 'Answer body' } }
            expect(Answer.last.user).to eq user
          end

          it 'check question association' do
            post "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token, answer: { body: 'Answer body' } }
            expect(Answer.last.question).to eq question
          end
        end

        context 'with invalid attributes' do
          it 'does not saves the answer in database' do
            expect{
              post "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token, answer: { body: '' } }
            }.to_not change(Answer, :count)
          end

          it 'returns status 422' do
            post "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token, answer: { body: '' } }
            expect(response.status).to eq 422
          end
        end

      end


    end

  end

end