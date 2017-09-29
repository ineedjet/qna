require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:comment) { create(:comment, commentable: question, user: user) }
  let!(:comment2) { create(:comment, commentable: question, user: user2) }

  describe 'PATCH #update' do

    context 'with same user' do
      before { sign_in_the_user(user) }

      it 'assign the update comment to @comment' do
        patch :update, params: { id: comment, comment: attributes_for(:comment) }, format: :js

        expect(assigns(:comment)).to eq comment
      end

      it 'change comment attributes' do
        patch :update, params: { id: comment, comment: { body: 'New body' } }, format: :js
        comment.reload

        expect(comment.body).to eq 'New body'
      end

      it 'change answer attributes' do
        patch :update, params: { id: comment, comment: { body: 'New body' } }, format: :js

        expect(response).to render_template 'comments/update'
      end

    end

    context 'with stranger user' do
      before { sign_in_the_user(user2) }

      it 'not change comment attributes' do
        comment_old_body = comment.body
        patch :update, params: { id: comment, comment: { body: 'New body' } }, format: :js
        comment.reload

        expect(comment.body).to eq comment_old_body
      end
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
