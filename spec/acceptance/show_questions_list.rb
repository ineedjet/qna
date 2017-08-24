require 'rails_helper'

feature 'Show questions list', %q{
  In order to get answer
  As any user
  I want to be able to look all questions
} do

  given (:user) { create(:user) }
  given (:question) { create(:question) }

  before { question }


  scenario 'Authenticated  user get questions list' do
    sign_in(user)
    visit questions_path
    expect(page).to have_content question.title
  end

  scenario 'Non-authenticated  user get questions list' do
    visit questions_path
    expect(page).to have_content question.title
  end
end