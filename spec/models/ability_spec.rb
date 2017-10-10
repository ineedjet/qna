require 'rails_helper'

RSpec.describe Ability , type: :model do
  subject(:ability) { Ability.new(user)  }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Attachment }

    it { should_not be_able_to :manage, :all  }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true}

    it { should be_able_to :manage, :all  }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:user2 ) { create :user }
    let(:question ) { create :question, user: user }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'Question' do
      it { should be_able_to :create, Question }

      it { should be_able_to :update, create(:question, user: user), user: user }
      it { should_not be_able_to :update, create(:question, user: user2), user: user }

      it { should be_able_to :destroy, question, user: user  }
      it { should_not be_able_to :destroy, create(:question, user: user2), user: user  }
    end

    context 'Answer' do
      it { should be_able_to :create, Answer }
      it { should be_able_to :update, create(:answer, question: question, user: user), user: user }
      it { should_not be_able_to :update, create(:answer, question: question , user: user2), user: user }

      it { should be_able_to :destroy, create(:answer, question: question, user: user), user: user }
      it { should_not be_able_to :destroy, create(:answer, question: question , user: user2), user: user }
    end

    context 'Comment' do
      it { should be_able_to :create, Comment, commentable: question }
      it { should be_able_to :update, create(:comment, commentable: question, user: user), user: user }
      it { should_not be_able_to :update, create(:comment, commentable: question , user: user2), user: user }

      it { should be_able_to :destroy, create(:comment, commentable: question, user: user), user: user }
      it { should_not be_able_to :destroy, create(:comment, commentable: question , user: user2), user: user }
    end

    context 'Attachment' do
      let(:question2) { create :question, user: user2 }

      it { should be_able_to :create, Attachment }

      it { should be_able_to :destroy, create(:attachment, attachable: question), user: user }
      it { should_not be_able_to :destroy, create(:attachment, attachable: question2), user: user }
    end







  end
end