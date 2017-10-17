require 'rails_helper'

describe 'Answer API' do
  let!(:question) {create(:question)}
  let(:user) {create(:user)}
  let(:access_token) {create(:access_token, resource_owner_id: user.id)}

  describe 'GET /index' do
    let!(:answers) {create_list(:answer, 3, question: question)}

    it_behaves_like 'API authenticable'
    it_behaves_like 'API successfuble'

    before {do_request(access_token: access_token.token)}

    it 'return list of answer for question' do
      expect(response.body).to have_json_size(3)
    end

    %w(id body created_at updated_at).each do |attr|
      it "answer object contains #{attr}" do
        answer = answers.first
        expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: {format: :json}.merge(options)
    end
  end

  describe '/show' do
    let!(:answer) {create(:answer, question: question)}
    let!(:comment) {create(:comment, commentable: answer)}
    let!(:answer_attachment) {create :attachment, attachable: answer}

    it_behaves_like 'API authenticable'
    it_behaves_like 'API successfuble'

    before {do_request(access_token: access_token.token)}

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

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: {format: :json}.merge(options)
    end
  end


  describe '/create' do

    context 'with valid attributes' do
      it_behaves_like 'API authenticable'

      it 'saves the new answer in the database' do
        expect {
          do_request(access_token: access_token.token)
        }.to change(Answer, :count).by(1)
      end

      it 'return the new answer' do
        do_request(access_token: access_token.token)
        expect(response.body).to be_json_eql('Answer body'.to_json).at_path('body')
      end

      it 'check user is author' do
        do_request(access_token: access_token.token)
        expect(Answer.last.user).to eq user
      end

      it 'check question association' do
        do_request(access_token: access_token.token)
        expect(Answer.last.question).to eq question
      end

      def do_request(options = {})
        post "/api/v1/questions/#{question.id}/answers", params: {format: :json, answer: {body: 'Answer body'}}.merge(options)
      end
    end

    context 'with invalid attributes' do
      it_behaves_like 'API authenticable'

      it 'does not saves the answer in database' do
        expect {do_request(access_token: access_token.token)}.to_not change(Answer, :count)
      end

      it 'returns status 422' do
        do_request(access_token: access_token.token)
        expect(response.status).to eq 422
      end

      def do_request(options = {})
        post "/api/v1/questions/#{question.id}/answers", params: {format: :json, answer: {body: ''}}.merge(options)
      end
    end
  end
end