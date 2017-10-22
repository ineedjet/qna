require 'rails_helper'

feature 'subscribe question', %q{
  In order to receive answers by mail
  As autorized user
  I want to be able to subscribe for questions
} do

  Capybara.exact = true

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:subscribed_question) { create(:question) }
  given!(:subscription) { create(:subscription, user: user, question: subscribed_question) }
  given!(:author) { create(:user) }
  given!(:authors_question) { create(:question, user: author) }

  scenario 'Unauthenticated user cant see subscribe buttons', js:true do
    visit question_path(question)
    expect(page).to_not have_link "subscribe"
    expect(page).to_not have_link "unsubscribe"
  end

  scenario 'Authenticated user can subscribe unsubscribed question', js:true do
    sign_in(user)
    visit question_path(question)
    expect(page).to have_link "subscribe"
    expect(page).to_not have_link "unsubscribe"
    click_on "subscribe"
    expect(page).to_not have_link "subscribe"
    expect(page).to have_link "unsubscribe"
  end

  scenario 'Authenticated user can unsubscribe subscribed question', js:true do
    sign_in(user)
    visit question_path(subscribed_question)
    expect(page).to_not have_link "subscribe"
    expect(page).to have_link "unsubscribe"
    click_on "unsubscribe"
    expect(page).to_not have_link "unsubscribe"
    expect(page).to have_link "subscribe"
  end

  scenario 'Author of question receive answers', js:true do
    sign_in(user)
    visit question_path(authors_question)
    within '.new_answer' do
      fill_in 'Body', with: 'Test answer body text'
      click_on 'Create answer'
    end
    open_email(author.email)
    expect(current_email).to have_content authors_question.title
    expect(current_email).to have_content 'Test answer body text'
  end

  scenario 'Author of question can unsubscribe and do not receive answers', js:true do
    sign_in(author)
    visit question_path(authors_question)
    click_on "unsubscribe"
    visit destroy_user_session_path

    sign_in(user)
    visit question_path(authors_question)
    within '.new_answer' do
      fill_in 'Body', with: 'Test answer body text'
      click_on 'Create answer'
    end
    open_email(author.email)
    expect(current_email).to eq nil
  end

  scenario 'Authenticated user stranger user do not receive answers', js:true do
    sign_in(author)
    visit question_path(authors_question)
    within '.new_answer' do
      fill_in 'Body', with: 'Test answer body text'
      click_on 'Create answer'
    end
    open_email(user.email)
    expect(current_email).to eq nil
  end

  scenario 'Authenticated user can subscrib question and receive answers', js:true do
    sign_in(user)
    visit question_path(authors_question)
    click_on "subscribe"
    visit destroy_user_session_path

    sign_in(author)
    visit question_path(authors_question)
    within '.new_answer' do
      fill_in 'Body', with: 'Test answer body text'
      click_on 'Create answer'
    end
    open_email(user.email)
    expect(current_email).to have_content authors_question.title
    expect(current_email).to have_content 'Test answer body text'
  end
end