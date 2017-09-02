require 'rails_helper'

feature 'User sign out', %q{
  In order to be able to sign out
  As an user
  I want to be able to sign out
} do

  given (:user) { create(:user) }

  scenario 'Registered user try to sign out' do
    sign_in(user)
    visit destroy_user_session_path

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end