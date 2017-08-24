require 'rails_helper'

feature 'Create answer', %q{
  In order to put answer
  As an authenticated user
  I want to be able to put answer for question
} do

  given (:user) { create(:user) }
  given (:question) { create(:question) }

  before{ question }

  scenario 'Authenticated  user creates answer for question' do
    sign_in(user)

    visit questions_path
    click_on question.title
    fill_in 'Body', with: 'Test answer body text text text text'
    click_on 'Create answer'

    expect(page).to have_content 'Your answer successfully created'
  end

  scenario 'Non-authenticated  user creates answer for question' do
    visit questions_path
    click_on question.title
    fill_in 'Body', with: 'Test answer body text text text text'
    click_on 'Create answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end