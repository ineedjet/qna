require 'rails_helper'

feature 'Delete answer', %q{
  In order to remove answer
  As an authenticated user
  I want to be able to remove my answer
} do

  given! (:user) { create(:user) }
  given! (:user2) { create(:user) }
  given! (:question) { create :question, user: user }
  given! (:answer) { create :answer, question: question, user: user }

  scenario 'User try delete his answer' do
    sign_in(user)

    visit questions_path
    click_on question.title
    click_on "Delete answer"

    expect(page).to have_content 'Your answer successfully deleted'
    expect(page).to have_no_content answer.body
    expect(current_path).to eq question_path(question)
  end

  scenario 'User try delete a strangers answer' do
    sign_in(user2)

    visit questions_path
    click_on question.title

    expect(page).to have_no_link "Delete answer"
    expect(current_path).to eq question_path(question)
  end

  scenario 'non-authenticated user try delete answer' do
    visit question_path(question)
    expect(page).to_not have_content('delete answer')
  end
end