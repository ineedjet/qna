require 'rails_helper'

describe 'Profile API' do

  describe 'GET /index' do
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
      let(:user) { create(:user) }
      let(:access_token) {create(:access_token, resource_owner_id: user.id) }

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
        let!(:question_attachment) { create :attachment, attachable: question }

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

        it 'attachments includes in question object' do
          expect(response.body).to have_json_size(1).at_path('attachments')
        end

        %w(id created_at updated_at).each do |attr|
          it "question contains attachments #{attr}" do
            expect(response.body).to be_json_eql(question_attachment.send(attr.to_sym).to_json).at_path("attachments/0/#{attr}")
          end
        end

        it "question contains attachments filename" do
          expect(response.body).to be_json_eql(question_attachment.file.file.filename.to_json).at_path("attachments/0/filename")
        end

        it "question contains attachments url" do
          expect(response.body).to be_json_eql(question_attachment.file.url.to_json).at_path("attachments/0/url")
        end

      end

      context '/create' do

        context 'with valid attributes' do

          it 'saves the new question in the database' do
            expect{
              post '/api/v1/questions', params: { format: :json, access_token: access_token.token, question: { body: 'Question body', title: 'Question title' } }
            }.to change(Question, :count).by(1)
          end

          it 'return the new question' do
            post '/api/v1/questions', params: { format: :json, access_token: access_token.token, question: { body: 'Question body', title: 'Question title' } }
            expect(response.body).to be_json_eql('Question body'.to_json).at_path('body')
            expect(response.body).to be_json_eql('Question title'.to_json).at_path('title')
          end

          it 'check user is author' do
            post '/api/v1/questions', params: { format: :json, access_token: access_token.token, question: { body: 'Question body', title: 'Question title' } }
            expect(Question.last.user).to eq user
          end
        end

        context 'with invalid attributes' do
          it 'does not saves the question in database' do
            expect{
              post '/api/v1/questions', params: { format: :json, access_token: access_token.token, question: { body: '', title: '' } }
            }.to_not change(Question, :count)
          end

          it 'returns status 422' do
            post '/api/v1/questions', params: { format: :json, access_token: access_token.token, question: { body: '', title: '' } }
            expect(response.status).to eq 422
          end
        end

      end

    end
  end

end