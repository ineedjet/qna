require 'rails_helper'

feature 'Delete question', %q{
  In order to remove question
  As an authenticated user
  I want to be able to remove my question
} do

  given! (:user) { create(:user) }
  given! (:user2) { create(:user) }
  given! (:question) { create :question, user: user }
  given! (:question2) { create :question, user: user2 }

  scenario 'User delete his question' do
    sign_in(user)

    visit question_path question
    click_on "Delete"

    expect(page).to have_content 'Your question successfully deleted'
  end

  scenario 'User try delete a strangers question' do
    sign_in(user)
    visit question_path question2

    expect(page).to have_no_link "Delete"
  end
end