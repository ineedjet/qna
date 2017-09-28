require 'rails_helper'

feature 'Create question', %q{
  In order to get answer
  As an authenticated user
  I want to be able to ask question
} do

  given (:user) { create(:user) }
  given (:question) { create(:question, user: user) }

  scenario 'Authenticated  user creates question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on 'Create'

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content 'Your question successfully created'
  end

  scenario 'Authenticated  user try to create invalid question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    click_on 'Create'

    expect(page).to have_content 'Title can\'t be blank'
    expect(page).to have_content 'Body can\'t be blank'
  end

  scenario 'Non-authenticated  user creates question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end

  context "multiply sessions" do
    scenario "question appear in anower user index question page", js:true do
      Capybara.using_session('guest') do
        visit questions_path

        expect(page).to_not have_content  "question title"
        expect(page).to_not have_content "question body"
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path

        click_on 'Ask question'
        fill_in 'Title', with: "question title"
        fill_in 'Body', with: "question body"
        click_on 'Create'

        expect(page).to have_content  "question title"
        expect(page).to have_content "question body"
      end

      Capybara.using_session('guest') do
        expect(page).to have_content  "question title"
        expect(page).to have_content "question body"
      end
    end

  end
end