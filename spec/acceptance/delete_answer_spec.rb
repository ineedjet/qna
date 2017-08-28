require 'rails_helper'

feature 'Delete answer', %q{
  In order to remove answer
  As an authenticated user
  I want to be able to remove my answer
} do

  given (:user) { create(:user) }
  given (:user2) { create(:user) }
  given (:question) { create :question, user: user }
  given (:answer) { create :answer, question: question, user: user }
  given (:answer2) { create :answer, question: question, user: user2 }

  before { user }
  before { user2 }
  before { question }
  before { answer }
  before { answer2 }

  scenario 'User delete his answer' do
    sign_in(user)

    visit questions_path
    click_on question.title
    click_on "Delete answer #{answer.id}"

    expect(page).to have_content 'Your answer successfully deleted'
  end

  scenario 'User try delete a strangers answer' do
    sign_in(user)

    visit questions_path
    click_on question.title

    expect(page).to have_no_link "Delete answer #{answer2.id}"
  end
end