require 'rails_helper'

feature 'Set best answer', %q{
  In order to set best answer
  As an authenticated user
  I want to be able to set best answer for my question
} do

  given! (:user) { create(:user) }
  given! (:user2) { create(:user) }
  given! (:question) { create :question, user: user }
  given! (:answer) { create :answer, question: question, user: user }
  given! (:answer2) { create :answer, question: question, user: user2 }

  scenario 'User try set best starngers answer for his question', js:true do
    sign_in(user)

    visit questions_path
    click_on question.title
    within "#answer-#{answer2.id}" do
      click_on "Set best answer"
    end
    expect(page).to have_content 'Answer successfully set best'

  end

  scenario 'User try set best his answer for his question', js:true do
    sign_in(user)

    visit questions_path
    click_on question.title
    within "#answer-#{answer.id}" do
      click_on "Set best answer"
    end
    expect(page).to have_content 'Answer successfully set best'

  end

  scenario 'User try set best answer a strangers question', js:true do
    sign_in(user2)

    visit questions_path
    click_on question.title

    expect(page).to have_no_link "Set best answer"
  end

  scenario 'non-authenticated user try set best answer' do
    visit question_path(question)
    expect(page).to have_no_link "Set best answer"
  end
end