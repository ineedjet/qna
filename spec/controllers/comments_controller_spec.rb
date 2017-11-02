require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:comment) { create(:comment, commentable: question, user: user) }
  let!(:comment2) { create(:comment, commentable: question, user: user2) }

  describe 'POST #create by user (for question)' do
    before{ sign_in_the_user(user) }

    context 'with valid attributes' do
      it 'saves the new comment in the database with commentsble association' do
        expect { post :create, params: { question_id: question.id, commentable: 'question', comment: attributes_for(:comment) }, format: :js }.to change(question.comments, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { question_id: question.id, commentable: 'question', comment: attributes_for(:comment)  }, format: :js
        expect(response).to render_template 'comments/create'
      end

      it 'check user is author' do
        post :create, params: { question_id: question.id, commentable: 'question', comment: attributes_for(:comment)  }, format: :js
        expect(assigns(:comment).user).to eq user
      end

      it 'check commentable is commentable' do
        post :create, params: { question_id: question.id, commentable: 'question', comment: attributes_for(:comment)  }, format: :js
        expect(assigns(:comment).commentable).to eq question
      end
    end

    context 'with invalid attributes' do
      it 'does not saves the answer in database' do
        expect { post :create, params: { question_id: question.id, commentable: "question", comment: attributes_for(:invalid_comment) }, format: :js }.to_not change(Comment, :count)
      end
    end

  end

  describe 'POST #create by anonymous (for question)' do
    context 'with valid attributes' do
      it 'saves the new comment in the database with commentsble association' do
        expect { post :create, params: { question_id: question.id, commentable: 'question', comment: attributes_for(:comment) }, format: :js }.to_not change(question.comments, :count)
      end
    end
  end

  describe 'POST #create by user (for answer)' do
    let!(:answer) { create(:answer, question: question, user: user) }

    before { sign_in_the_user(user) }

    context 'with valid attributes' do
      it 'saves the new comment in the database with commentsble association' do
        expect { post :create, params: { answer_id: answer.id, commentable: 'answer', comment: attributes_for(:comment) }, format: :js }.to change(answer.comments, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { answer_id: answer.id, commentable: 'answer', comment: attributes_for(:comment)  }, format: :js
        expect(response).to render_template 'comments/create'
      end

      it 'check user is author' do
        post :create, params: { answer_id: answer.id, commentable: 'answer', comment: attributes_for(:comment)  }, format: :js
        expect(assigns(:comment).user).to eq user
      end

      it 'check commentable is commentable' do
        post :create, params: { answer_id: answer.id, commentable: 'answer', comment: attributes_for(:comment)  }, format: :js
        expect(assigns(:comment).commentable).to eq answer
      end
    end

    context 'with invalid attributes' do
      it 'does not saves the answer in database' do
        expect { post :create, params: { answer_id: answer.id, commentable: "answer", comment: attributes_for(:invalid_comment) }, format: :js }.to_not change(Comment, :count)
      end
    end

  end

  describe 'POST #create by anonymous (for answer)' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'with valid attributes' do
      it 'saves the new comment in the database with commentsble association' do
        expect { post :create, params: { answer_id: answer.id, commentable: 'answer', comment: attributes_for(:comment) }, format: :js }.to_not change(answer.comments, :count)
      end
    end
  end


  describe 'PATCH #update' do

    context 'with same user' do
      let(:action) { 'comments/update' }
      before do
        sign_in_the_user(user)
        patch :update, params: { id: comment, comment: { body: 'New body' } }, format: :js
      end

      it 'assign the update comment to @comment' do
        expect(assigns(:comment)).to eq comment
      end

      it 'change comment attributes' do
        comment.reload
        expect(comment.body).to eq 'New body'
      end

      it_behaves_like 'render-templatable'

    end

  end


  describe  'DELETE #destroy' do

    context 'with same user' do
      before { sign_in_the_user(user) }

      it 'deletes comment' do
        expect { delete :destroy, params: { id: comment }, format: :js }.to change(question.comments, :count).by(-1)
      end

      it 'no redirect to question view' do
        delete :destroy, params: { id: comment }, format: :js
        expect(response).to render_template 'comments/destroy'
      end
    end

    context 'with stranger user' do

      it 'deletes answer' do
        expect { delete :destroy, params: { id: comment2 }, format: :js }.to_not change(question.comments, :count)
      end

    end
  end

end
