require 'rails_helper'

feature 'Edit question', %q{
  In order to fix question
  As an authenticated user
  I want to be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  context 'User edit his answer' do

    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'User can see edit link for his answer' do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'User can edit his answer', js:true do
      answer_body_old = answer.body
      click_on 'Edit'
      within '.answers' do
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to have_content'edited answer'
        expect(page).to_not have_content answer_body_old
        expect(page).to_not have_selector 'textarea'
      end
    end

  end

  scenario 'User try edit strangers answer' do
    sign_in user2
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Unautorized user try edit answer' do
    expect(page).to_not have_link 'Edit'
  end

end
