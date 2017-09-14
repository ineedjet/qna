require 'rails_helper'

feature 'Delete answer', %q{
  In order to remove answer
  As an authenticated user
  I want to be able to remove my answer
} do

  given! (:user) { create(:user) }
  given! (:question) { create :question, user: user }
  given! (:answer) { create :answer, question: question, user: user }
  given! (:question_attachment) { create :attachment, attachable: question }
  given! (:answer_attachment) { create :attachment, attachable: answer }

  scenario 'User try delete his answers attachment', js:true do
    sign_in(user)

    visit question_path(question)
    within '.question' do
      click_on "Delete attachment"
      expect(page).to have_no_content question_attachment.file.file.filename
    end

    expect(page).to have_content 'Your attachment successfully deleted'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(current_path).to eq question_path(question)
  end

  #scenario 'User try delete his question attachment', js:true do
  #  sign_in(user2)

  #  visit questions_path
  #  click_on question.title

  #  expect(page).to have_no_link "Delete answer"
  #  expect(current_path).to eq question_path(question)
  #end

  #scenario 'non-authenticated user try delete answer' do
  #  visit question_path(question)
  #  expect(page).to_not have_content('Delete answer')
  #end
end