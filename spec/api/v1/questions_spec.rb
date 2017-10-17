require 'rails_helper'

describe 'Question API' do
  let(:user) {create(:user)}
  let(:access_token) {create(:access_token, resource_owner_id: user.id)}

  describe '/index' do
    let!(:questions) {create_list(:question, 3)}

    it_behaves_like 'API authenticable'
    it_behaves_like 'API successfuble'

    before {do_request(access_token: access_token.token)}

    it 'return list of questions' do
      expect(response.body).to have_json_size(3)
    end

    %w(id title body created_at updated_at).each do |attr|
      it "question object contains #{attr}" do
        question = questions.first
        expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr).at_path("0/#{attr}")
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', params: {format: :json}.merge(options)
    end
  end

  describe '/show' do
    let!(:question) {create(:question)}
    let!(:comment) {create(:comment, commentable: question)}
    let!(:question_attachment) {create :attachment, attachable: question}

    it_behaves_like 'API authenticable'
    it_behaves_like 'API successfuble'

    before {do_request(access_token: access_token.token)}

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

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", params: {format: :json}.merge(options)
    end
  end

  describe '/create' do

    context 'with valid attributes' do
      it_behaves_like 'API authenticable'

      it 'saves the new question in the database' do
        expect {do_request(access_token: access_token.token)}.to change(Question, :count).by(1)
      end

      it 'return the new question' do
        do_request(access_token: access_token.token)
        expect(response.body).to be_json_eql('Question body'.to_json).at_path('body')
        expect(response.body).to be_json_eql('Question title'.to_json).at_path('title')
      end

      it 'check user is author' do
        do_request(access_token: access_token.token)
        expect(Question.last.user).to eq user
      end

      def do_request(options = {})
        post '/api/v1/questions', params: {format: :json, question: {body: 'Question body', title: 'Question title'}}.merge(options)
      end
    end

    context 'with invalid attributes' do
      it_behaves_like 'API authenticable'

      it 'does not saves the question in database' do
        expect {do_request(access_token: access_token.token)}.to_not change(Question, :count)
      end

      it 'returns status 422' do
        do_request(access_token: access_token.token)
        expect(response.status).to eq 422
      end

      def do_request(options = {})
        post '/api/v1/questions', params: {format: :json, question: {body: '', title: ''}}.merge(options)
      end
    end
  end
end
