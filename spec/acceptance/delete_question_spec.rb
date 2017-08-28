require 'rails_helper'

feature 'Delete question', %q{
  In order to remove question
  As an authenticated user
  I want to be able to remove my question
} do

  given (:user) { create(:user) }
  given (:user2) { create(:user) }
  given (:question) { create :question, user: user }
  given (:question2) { create :question, user: user2 }

  before { user }
  before { user2 }
  before { question }
  before { question2 }

  scenario 'User delete his question' do
    sign_in(user)

    visit questions_path
    click_on(".question-id-#{question.id}-delete")

    expect(page).to have_content 'Your question successfully deleted'
  end

  scenario 'User try delete a strangers question' do
    visit questions_path

    expect(page).to have_not_content ".question-id-#{question2.id}-delete"
  end
end