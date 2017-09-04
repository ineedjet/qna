require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:answer2) { create(:answer, question: question, user: user2) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer in the database with question association' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer)  }, format: :js
        expect(response).to render_template 'answers/create'
      end

      it 'check user is author' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer)  }, format: :js
        expect(assigns(:answer).user).to eq @user
      end
    end

    context 'with invalid attributes' do
      it 'does not saves the answer in database' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer) }, format: :js }.to_not change(Answer, :count)
      end

      it 'render create template' do
        post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer) }, format: :js
        expect(response).to render_template 'answers/create'
      end
    end

  end

  describe  'DELETE #destroy' do
    sign_in_user
    before { answer.update(user_id: @user.id) }

    context 'with same user' do

      it 'deletes answer' do
        expect { delete :destroy, params: { question_id: question.id, id: answer } }.to change(question.answers, :count).by(-1)
      end

      it 'redirect to question view' do
        delete :destroy, params: { question_id: question.id, id: answer }
        expect(response).to redirect_to question_path
      end
    end

    context 'with stranger user' do

      it 'deletes answer' do
        expect { delete :destroy, params: { question_id: question.id, id: answer2 } }.to_not change(question.answers, :count)
      end

      it 'redirect to question view' do
        delete :destroy, params: { question_id: question.id, id: answer2 }
        expect(response).to redirect_to question_path(question)
      end
    end
  end

end
