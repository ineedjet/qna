require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe  'DELETE #destroy for question attachment' do
    let!(:question_attachment) { create :attachment, attachable: question }

    sign_in_user

    context 'with same user' do
      before { question.update(user_id: @user.id) }

      it 'deletes question' do
        expect { delete :destroy, params: { id: question_attachment }, format: :js }.to change(question.attachments, :count).by(-1)
      end

      it 'render ' do
        delete :destroy, params: { id: question_attachment }, format: :js
        expect(response).to render_template 'attachments/destroy'
      end
    end

    context 'with stranger user' do
      it 'deletes question' do
        expect { delete :destroy, params: { id: question_attachment }, format: :js }.to_not change(question.attachments, :count)
      end

    end
  end

  describe  'DELETE #destroy for question attachment' do
    let(:answer) { create(:answer, question: question, user: user ) }
    let!(:answer_attachment) { create :attachment, attachable: answer }

    sign_in_user

    context 'with same user' do
      before { answer.update(user_id: @user.id) }

      it 'deletes question' do
        expect { delete :destroy, params: { id: answer_attachment }, format: :js }.to change(answer.attachments, :count).by(-1)
      end

      it 'render ' do
        delete :destroy, params: { id: answer_attachment }, format: :js
        expect(response).to render_template 'attachments/destroy'
      end
    end

    context 'with stranger user' do
      it 'deletes question' do
        expect { delete :destroy, params: { id: answer_attachment }, format: :js }.to_not change(answer.attachments, :count)
      end

    end
  end
end
