require 'rails_helper'

feature 'Vote question', %q{
  In order to choise best question
  As autorized user
  I want to be able to vote for questions
} do

  given! (:user) { create(:user) }
  given! (:user2) { create(:user) }
  given! (:question) { create(:question, user: user) }

  scenario 'Unauthenticated  user cant vote' do
    visit question_path(question)
    expect(page).to_not have_content "vote +1"
    expect(page).to_not have_content "vote -1"
    expect(page).to_not have_content "delete vote"
  end

  scenario 'Authenticated user cant vote for his question' do
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_content "vote +1"
    expect(page).to_not have_content "vote -1"
    expect(page).to_not have_content "delete vote"
  end

  scenario 'Authenticated user can vote for strangers question' do
    sign_in(user2)
    visit question_path(question)
    expect(page).to have_content "vote +1"
    expect(page).to have_content "vote -1"
    expect(page).to have_content "delete vote"
  end
end