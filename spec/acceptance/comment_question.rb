require 'rails_helper'

feature 'Create answer', %q{
  In order to put answer
  As an authenticated user
  I want to be able to put answer for question
} do

  given! (:user) { create(:user) }
  given! (:question) { create(:question, user: user) }

  scenario 'Authenticated  user creates comment for question', js: true do
    sign_in(user)

    visit questions_path
    click_on question.title
    within "#Question-#{question.id}" do
      within '.new_comment' do
        fill_in 'Body', with: 'Test answer body text text text text'
        click_on 'Create comment'
      end
      expect(page).to have_content 'Test answer body text text text text'
    end
    expect(page).to have_content 'Your comment successfully created'

  end

  scenario 'Authenticated  user try to create invalid comment for question', js:true do
    sign_in(user)

    visit questions_path
    click_on question.title
    within "#Question-#{question.id}" do
      within '.new_comment' do
        click_on 'Create comment'
      end
      expect(page).to have_content 'Body can\'t be blank'
      end
  end

  scenario 'Non-authenticated  user creates answer for question', js:true do
    visit questions_path
    click_on question.title

    expect(page).to have_no_button 'Create comment'
  end

  context "multiply sessions" do
    given! (:question2) { create(:question, user: user) }

    scenario "answer appear in anower user index question page", js:true do
      Capybara.using_session('guest') do
        visit question_path(question)

        expect(page).to_not have_content "Test comment body"
      end

      Capybara.using_session('guest2') do
        visit question_path(question2)

        expect(page).to_not have_content "Test comment body"
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
        within "#Question-#{question.id}" do
          within '.new_comment' do
            fill_in 'Body', with: 'Test comment body'
            click_on 'Create comment'
          end
          expect(page).to have_content "Test comment body"
        end
      end

      Capybara.using_session('guest') do
        within "#Question-#{question.id}" do
          expect(page).to have_content "Test comment body"
        end
      end

      Capybara.using_session('guest2') do
        expect(page).to_not have_content "Test comment body"
      end
    end

  end
end