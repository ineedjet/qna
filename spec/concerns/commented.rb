require 'rails_helper'

shared_examples "commented" do
  let(:model) { described_class.controller_name.classify }
  let!(:user) { create(:user) }
  let!(:commentable) { create(model.underscore.to_sym, user: user) }

  describe 'POST #comment by user' do
    before{ sign_in_the_user(user) }

    context 'with valid attributes' do
      it 'saves the new comment in the database with commentsble association' do
        expect { post :comment, params: { id: commentable, comment: attributes_for(:comment) }, format: :js }.to change(commentable.comments, :count).by(1)
      end

      it 'render create template' do
        post :comment, params: { id: commentable, comment: attributes_for(:comment)  }, format: :js
        expect(response).to render_template 'comments/create'
      end

      it 'check user is author' do
        post :comment, params: { id: commentable, comment: attributes_for(:comment)  }, format: :js
        expect(assigns(:comment).user).to eq user
      end

      it 'check commentable is commentable' do
        post :comment, params: { id: commentable, comment: attributes_for(:comment)  }, format: :js
        expect(assigns(:comment).commentable).to eq commentable
      end
    end

    context 'with invalid attributes' do
      it 'does not saves the answer in database' do
        expect { post :comment, params: { id: commentable, comment: attributes_for(:invalid_comment) }, format: :js }.to_not change(Comment, :count)
      end
    end

  end

  describe 'POST #comment by anonimous' do
    context 'with valid attributes' do
      it 'saves the new comment in the database with commentsble association' do
        expect { post :comment, params: { id: commentable, comment: attributes_for(:comment) }, format: :js }.to_not change(commentable.comments, :count)
      end
    end
  end

end