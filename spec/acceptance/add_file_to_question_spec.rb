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

  scenario 'User add file then ask question' do

    fill_in 'Title', with: "question title"
    fill_in 'Body', with: "question body"
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end
end