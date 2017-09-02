require 'rails_helper'

RSpec.describe User do
  it {should have_many(:questions).dependent(:destroy)}
  it {should have_many(:answers).dependent(:destroy)}
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  context 'check author_of?' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'user is author' do
      expect(user).to be_author_of(question)
    end

    it 'user is not author' do
      expect(user2).to_not be_author_of(question)
    end
  end
end