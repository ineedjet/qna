require 'rails_helper'

feature 'Authentication with facebook', %q{
  In order to authenticate
  As an user
  I want to be able to authenticate from facebook account
} do

  context 'user signs in from facebook account for the first time' do
    scenario 'can sign in from facebook account' do
      visit root_path
      click_on 'Ask question'

      mock_facebook_hash
      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Successfully authenticated from Facebook account.'
      expect(page).to have_content 'Завершить сессию'
    end
  end

  context 'user signs in from facebook account for the second time' do
    given!(:user) { create(:user) }
    given!(:authorization) { create(:authorization, provider: 'facebook', uid: '123456', user: user) }

    scenario 'can sign in from facebook account' do
      visit root_path
      click_on 'Ask question'

      mock_facebook_hash
      click_on 'Sign in with Facebook'

      expect(current_path).to eq new_question_path
      expect(page).to have_content 'Successfully authenticated from Facebook account.'
      expect(page).to have_content 'Завершить сессию'
    end
  end

  context 'invalid credentials' do
    scenario "can handle authentication error" do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      visit root_path
      click_on 'Ask question'
      click_on 'Sign in with Facebook'
      expect(page).to have_content('Could not authenticate you from Facebook because "Invalid credentials".')
    end
  end

end