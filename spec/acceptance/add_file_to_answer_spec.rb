require 'rails_helper'

feature 'Add file to answer', %q{
  In order to illustrate answer
  As an answer author
  I want to be able to attach file
} do

  given (:user) { create(:user) }
  given (:question) { create(:question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User can add many files when answering', js: true do
    within '.new_answer' do
      fill_in 'Body', with: 'answer body'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'add file'
      within all('.nested-fields').last do
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      end
      click_on 'Create answer'
    end

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
    expect(page).to have_content 'Your answer successfully created'
    expect(page).to_not have_css '.nested-fields'
  end
end