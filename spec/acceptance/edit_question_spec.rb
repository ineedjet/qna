require 'rails_helper'

feature 'Edit question', %q{
  In order to fix question
  As an authenticated user
  I want to be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }

  context 'User edit his question' do

    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'User can see edit link for his answer' do
      within '.question' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'User can edit his question', js:true do
      question_body_old = question.body
      question_title_old = question.title
      click_on 'Edit'
      within '.edit_question' do
        fill_in 'Title', with: 'edited question title'
        fill_in 'Body', with: 'edited question body'
        click_on 'Save question'
      end

      expect(page).to have_content 'edited question title'
      expect(page).to have_content 'edited question body'
      expect(page).to_not have_content question_body_old
      expect(page).to_not have_content question_title_old
      expect(page).to_not have_selector '.edit_question'


    end

  end

  scenario 'User try edit strangers question' do
    sign_in user2
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Unautorized user try edit question' do
    expect(page).to_not have_link 'Edit'
  end

end
