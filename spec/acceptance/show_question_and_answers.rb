require 'rails_helper'

feature 'Show question and answers', %q{
  In order to read answer
  As any user
  I want to be able to look a question and answers for it
} do

  given (:user) { create(:user) }
  given (:question) { create(:question) }
  given (:answers) { create_list(:answer, 2, question: question) }

  before { question }
  before { answers }

  scenario 'Authenticated  user get question and answers list' do
    sign_in(user)
    visit questions_path
    click_on question.title
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

  scenario 'Non-authenticated  user get question and answers list' do
    visit questions_path
    click_on question.title
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end