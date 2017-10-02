require 'rails_helper'

feature 'Delete question', %q{
  In order to remove question
  As an authenticated user
  I want to be able to remove my question
} do

  given! (:user) { create(:user) }
  given! (:user2) { create(:user) }
  given (:question) { create :question, user: user }
  given (:question2) { create :question, user: user2 }

  scenario 'User delete his question' do
    sign_in(user)

    visit question_path question
    click_on "Delete question"

    expect(page).to have_content 'Your Question successfully deleted'
    expect(page).to have_no_content question.title
  end

  scenario 'User try delete a strangers question' do
    sign_in(user)
    visit question_path question2

    expect(page).to have_no_link "Delete question"
  end

  scenario 'non-authenticated user try delete question' do
    visit question_path(question)
    expect(page).to_not have_content('Delete question')
  end
end