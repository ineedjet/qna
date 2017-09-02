require 'rails_helper'

feature 'User register', %q{
  In order to be able to ask question
  As an non-rerister user
  I want to be able to register
} do

  given (:user) { create(:user) }

  scenario 'Unregistered user try to register' do
    visit new_user_registration_path
    fill_in 'Email', with: 'my@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Registered user try to register' do
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
    expect(current_path).to_not eq root_path
  end
end