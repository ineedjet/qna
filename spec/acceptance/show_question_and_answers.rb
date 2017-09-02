require 'rails_helper'

feature 'Show question and answers', %q{
  In order to read answer
  As any user
  I want to be able to look a question and answers for it
} do

  given! (:user) { create(:user) }
  given! (:question) { create(:question, user: user) }
  given! (:answers) { create_list(:answer, 2, question: question, user: user) }

  scenario 'Authenticated  user get question and answers list' do
    sign_in(user)
    visit questions_path
    click_on question.title

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

  scenario 'Non-authenticated  user get question and answers list' do
    visit questions_path
    click_on question.title

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end