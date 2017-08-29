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

  before { user }
  before { user2 }
  before { question }
  before { question2 }

  scenario 'User delete his question' do
    sign_in(user)

    visit questions_path
    click_on "Delete #{question.id}"

    expect(page).to have_content 'Your question successfully deleted'
  end

  scenario 'User try delete a strangers question' do
    sign_in(user)
    visit questions_path

    expect(page).to have_no_link "Delete #{question2.id}"
  end
end