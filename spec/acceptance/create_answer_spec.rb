require 'rails_helper'

feature 'Create answer', %q{
  In order to put answer
  As an authenticated user
  I want to be able to put answer for question
} do

  given! (:user) { create(:user) }
  given! (:question) { create(:question, user: user) }

  scenario 'Authenticated  user creates answer for question', js: true do
    sign_in(user)

    visit questions_path
    click_on question.title
    fill_in 'Body', with: 'Test answer body text text text text'
    click_on 'Create answer'

    expect(page).to have_content 'Your answer successfully created'
    expect(page).to have_content 'Test answer body text text text text'
  end

  scenario 'Authenticated  user try to create invalid answer for question', js:true do
    sign_in(user)

    visit questions_path
    click_on question.title
    click_on 'Create answer'

    expect(page).to have_content 'Body can\'t be blank'
  end

  scenario 'Non-authenticated  user creates answer for question', js:true do
    visit questions_path
    click_on question.title

    expect(page).to have_no_button 'Create answer'
  end

  context "multiply sessions" do
    given! (:question2) { create(:question, user: user) }

    scenario "answer appear in anower user index question page", js:true do
      Capybara.using_session('guest') do
        visit question_path(question)

        expect(page).to_not have_content "Test answer body"
      end

      Capybara.using_session('guest2') do
        visit question_path(question2)

        expect(page).to_not have_content "Test answer body"
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)

        fill_in 'Body', with: 'Test answer body'
        click_on 'Create answer'

        expect(page).to have_content "Test answer body"
      end

      Capybara.using_session('guest') do
        expect(page).to have_content "Test answer body"
      end

      Capybara.using_session('guest2') do
        expect(page).to_not have_content "Test answer body"
      end
    end

  end
end