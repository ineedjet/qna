require 'rails_helper'

feature 'Create comment for answer', %q{
  In order to put comment
  As an authenticated user
  I want to be able to put comment for answer
} do

  given! (:user) { create(:user) }
  given! (:question) { create(:question, user: user) }
  given! (:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated  user creates comment for answer', js: true do
    sign_in(user)

    visit question_path(question)
    within "#Answer-#{answer.id}" do
      within '.new_comment' do
        fill_in 'Body', with: 'Test comment body text text text text'
        click_on 'Create comment'
      end
      expect(page).to have_content 'Test comment body text text text text'
    end
    expect(page).to have_content 'Your comment successfully created'

  end

  scenario 'Authenticated  user try to create invalid comment for answer', js:true do
    sign_in(user)

    visit question_path(question)
    within "#Answer-#{answer.id}" do
      within '.new_comment' do
        click_on 'Create comment'
      end
      expect(page).to have_content 'Body can\'t be blank'
      end
  end

  scenario 'Non-authenticated  user creates comment for answer', js:true do
    visit question_path(question)

    expect(page).to have_no_button 'Create comment'
  end

  context "multiply sessions" do
    given! (:answer2) { create(:answer, question: question, user: user) }

    scenario "answer appear in anower user index question page", js:true do
      Capybara.using_session('guest') do
        visit question_path(question)

        expect(page).to_not have_content "Test comment body"
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
        within "#Answer-#{answer.id}" do
          within '.new_comment' do
            fill_in 'Body', with: 'Test comment body'
            click_on 'Create comment'
          end
          expect(page).to have_content "Test comment body"
        end
      end

      Capybara.using_session('guest') do
        within "#Question-#{answer.id}" do
          expect(page).to have_content "Test comment body"
        end
        within "#Question-#{answer2.id}" do
          expect(page).to_not have_content "Test comment body"
        end
      end

    end

  end
end