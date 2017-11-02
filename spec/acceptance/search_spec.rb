require 'rails_helper'

feature 'Search for user, question, answer, comment', %q{
  In order to find similar question
  As anybody
  I want to be able to full-text search for user, question, answer, comment
} do

  given!(:user) { create(:user, email: 'test@email.com') }
  given!(:question) { create(:question, title: 'question test title', body: 'question body') }
  given!(:answer) { create(:answer, body: 'answer test body') }
  given!(:comment) { create(:comment, body: 'test comment body', commentable: question) }

  scenario 'User make unspecific search', js:true do
    ThinkingSphinx::Test.run do
      visit root_path
      within '.search-form' do
        select 'All', from: 'for'
        fill_in 'q', with: 'test'
        click_on 'Find'
      end

      within '#search_results' do
        expect(page).to have_content 'Question'
        expect(page).to have_content question.title
        expect(page).to have_content 'Answer'
        expect(page).to have_content answer.body
        expect(page).to have_content 'Comment'
        expect(page).to have_content comment.body
        expect(page).to have_content 'User'
        expect(page).to have_content user.email
      end
    end
  end

  %w(Answer Question User Comment).each do |search_object|
    scenario "User make #{search_object} search", js:true do
      ThinkingSphinx::Test.run do
        visit root_path
        within '.search-form' do
          select search_object, from: 'for'
          fill_in 'q', with: 'test'
          click_on 'Find'
        end

        within '#search_results' do
          expect(page).to have_content search_object
        end
      end
    end
  end
end