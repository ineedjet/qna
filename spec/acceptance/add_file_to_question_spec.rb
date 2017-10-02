require 'rails_helper'

feature 'Add filr to question', %q{
  In order to illustrate question
  As an question author
  I want to be able to attach file
} do

  given (:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User can add many files when ask a question', js: true do
    fill_in 'Title', with: 'question title'
    fill_in 'Body', with: 'question body'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'add file'
    within all('.nested-fields').last do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'

    expect(page).to have_content 'Your Question successfully created'
  end
end