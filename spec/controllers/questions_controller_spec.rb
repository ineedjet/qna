require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:question2) { create(:question, user: user2) }

  describe 'GET #index' do
    let!(:questions) { create_list(:question, 2, user: user) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:answers) { create_list(:answer, 2, question: question, user: user) }

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns the new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns the new answer to question' do
      expect(assigns(:answer).question).to eq question
    end

    it 'assigns the answers to @answers' do
      expect(assigns(:answers)).to match_array(answers)
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns the new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user

    before { get :edit,  params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'check user is author' do
        post :create, params: { question: attributes_for(:question) }
        expect(assigns(:question).user).to eq @user
      end
    end

    context 'with invalid attributes' do
      it 'does not saves the question in database' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-render new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end

  end


  describe 'PATCH #update' do

    context 'with same user' do
      sign_in_user
      before { question.update(user_id: @user.id) }

      it 'assign the update question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js

        expect(assigns(:question)).to eq question
      end

      it 'change question attributes' do
        patch :update, params: { id: question, question: { title: "New title", body: 'New body' } }, format: :js
        question.reload

        expect(question.title).to eq 'New title'
        expect(question.body).to eq 'New body'
      end

      it 'change question attributes render' do
        patch :update, params: { id: question, question: { title: "New title", body: 'New body' } }, format: :js

        expect(response).to render_template 'questions/update'
      end


    end

    context 'with same user and invalid attributes' do
      sign_in_user
      before do
        question.update(user_id: @user.id)
        patch :update, params: { id: question, question: { title:'new title', body: nil } }, format: :js
      end

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

    end

    context 'with stranger user' do
      sign_in_user

      it 'change answer attributes' do
        question_old_title = question.title
        question_old_body = question.body
        patch :update, params: { id: question, question: { title: "New title", body: 'New body' } }, format: :js
        question.reload

        expect(question.title).to eq question_old_title
        expect(question.body).to eq question_old_body
      end
    end

  end

  describe  'DELETE #destroy' do
    sign_in_user
    before { question.update(user_id: @user.id) }

    context 'with same user' do
      it 'deletes question' do
        expect { delete :destroy, params: { id: question } }.to change(@user.questions, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'with stranger user' do
      before { question2 }

      it 'deletes question' do
        expect { delete :destroy, params: { id: question2 } }.to_not change(user2.questions, :count)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: question2 }
        expect(response).to redirect_to questions_path
      end
    end
  end

end
