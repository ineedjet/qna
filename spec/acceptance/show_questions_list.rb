require 'rails_helper'

feature 'Show questions list', %q{
  In order to get answer
  As any user
  I want to be able to look all questions
} do

  given (:user) { create(:user) }
  given (:questions) { create_list(:question, 3) }

  before { questions }

  scenario 'Authenticated  user get questions list' do
    sign_in(user)
    visit questions_path
    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      end
  end

  scenario 'Non-authenticated  user get questions list' do
    visit questions_path
    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end