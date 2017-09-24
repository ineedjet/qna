require 'rails_helper'

feature 'Vote answer', %q{
  In order to choise best answer
  As autorized user
  I want to be able to vote for answers
} do

  given! (:user) { create(:user) }
  given! (:user2) { create(:user) }
  given! (:question) { create(:question, user: user) }
  given! (:answer) { create(:answer, question: question, user: user) }
  given! (:user3) { create(:user) }
  given! (:vote) { create(:vote, votable: answer, user: user3, vote_type: 'positive') }


  scenario 'Unauthenticated  user cant vote', js:true do
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_content "vote +1"
      expect(page).to_not have_content "vote -1"
      expect(page).to have_content "rating: 1"
      expect(page).to_not have_content "delete vote"
    end
  end

  scenario 'Authenticated user cant vote for his answer', js:true do
    sign_in(user)
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_content "vote +1"
      expect(page).to_not have_content "vote -1"
      expect(page).to have_content "rating: 1"
      expect(page).to_not have_content "delete vote"
    end
  end

  scenario 'Authenticated user can vote for strangers answer', js:true do
    sign_in(user2)
    visit question_path(question)
    within '.answers' do
      expect(page).to have_content "vote +1"
      expect(page).to have_content "vote -1"
      expect(page).to have_content "rating: 1"
      expect(page).to_not have_content "delete vote"
    end
  end

  scenario 'Authenticated user can vote positive for strangers answer', js:true do
    sign_in(user2)
    visit question_path(question)
    within '.answers' do
      expect(page).to have_content "rating: 1"
      click_on "vote +1"
      expect(page).to_not have_content "vote +1"
      expect(page).to_not have_content "vote -1"
      expect(page).to have_content "rating: 2"
      expect(page).to have_content "delete vote"
    end
  end

  scenario 'Authenticated user can vote negative for strangers answer', js:true do
    sign_in(user2)
    visit question_path(question)
    within '.answers' do
      expect(page).to have_content "rating: 1"
      click_on "vote -1"
      expect(page).to_not have_content "vote +1"
      expect(page).to_not have_content "vote -1"
      expect(page).to have_content "rating: 0"
      expect(page).to have_content "delete vote"
    end
  end

  scenario 'Authenticated user can revote for strangers answer', js:true do
    sign_in(user3)
    visit question_path(question)
    within '.answers' do
      expect(page).to have_content "rating: 1"
      click_on "delete vote"
      expect(page).to have_content "rating: 0"
      expect(page).to_not have_content "delete vote"
      click_on "vote -1"
      expect(page).to have_content "rating: -1"
      expect(page).to have_content "delete vote"
    end
  end
end