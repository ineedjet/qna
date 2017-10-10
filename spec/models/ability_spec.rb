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
end