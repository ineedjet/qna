require 'rails_helper'

feature 'subscribe question', %q{
  In order to receive answers by mail
  As autorized user
  I want to be able to subscribe for questions
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:subscribed_question) { create(:question) }
  given!(:subscription) { create(:subscription, user: user, question: subscribed_question) }

  scenario 'Unauthenticated user cant see subscribe buttons', js:true do
    visit question_path(question)
    expect(page).to_not have_link "make subscribe"
    expect(page).to_not have_link "unsubscribe"
  end

  scenario 'Authenticated user can subscribe unsubscribed question', js:true do
    sign_in(user)
    visit question_path(question)
    expect(page).to have_link "make subscribe"
    expect(page).to_not have_link "unsubscribe"
    click_on "make subscribe"
    expect(page).to_not have_link "make subscribe"
    expect(page).to have_link "unsubscribe"
  end

  scenario 'Authenticated user can unsubscribe subscribed question', js:true do
    sign_in(user)
    visit question_path(subscribed_question)
    expect(page).to_not have_link "make subscribe"
    expect(page).to have_link "unsubscribe"
    click_on "unsubscribe"
    expect(page).to have_link "make subscribe"
    expect(page).to_not have_link "unsubscribe"
  end

end