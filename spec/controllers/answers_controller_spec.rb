require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:answer2) { create(:answer, question: question, user: user2) }

  describe 'GET #new' do
    sign_in_user

    before { get :new,  params: { question_id: question.id } }

    it 'assigns the new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns the new answer to question' do
      expect(assigns(:answer).question).to eq question
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer in the database with question association' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'redirect to show answers question view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not saves the answer in database' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
      end

      it 're-render new view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer) }
        expect(response).to render_template :new
      end
    end

  end

  describe  'DELETE #destroy' do
    before { user }
    before { user2 }
    before { question }

    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
    end

    context 'with same user' do
      before { answer }

      it 'deletes answer' do
        expect { delete :destroy, params: { question_id: question.id, id: answer } }.to change(question.answers, :count).by(-1)
      end

      it 'redirect to question view' do
        delete :destroy, params: { question_id: question.id, id: answer }
        expect(response).to redirect_to question_path
      end
    end

    context 'with stranger user' do
      before { answer2 }

      it 'deletes answer' do
        expect { delete :destroy, params: { question_id: question.id, id: answer2 } }.to change(question.answers, :count).by(0)
      end

      it 'redirect to question view' do
        delete :destroy, params: { question_id: question.id, id: answer2 }
        expect(response).to redirect_to question_path
      end
    end
  end

end
