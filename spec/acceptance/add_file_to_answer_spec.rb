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

  scenario 'User add file then send answer', js: true do
    within '#new_answer' do
      fill_in 'Body', with: "answer body"
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Create'
    end

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'

  end
end