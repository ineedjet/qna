require 'rails_helper'

feature 'Authentication with twitter', %q{
  In order to authenticate
  As an user
  I want to be able to authenticate from twitter account
} do

  context 'user signs in from twitter account for the first time' do
    scenario 'can sign in from twitter account' do
      visit root_path
      click_on 'Ask question'

      mock_twitter_hash
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Укажите e-mail.'
      fill_in 'Email', with: 'test@email.com'
      click_on 'Send'

      expect(current_path).to eq new_question_path
      expect(page).to have_content 'Завершить сессию'
    end
  end

  context 'user signs in from twitter account for the second time' do
    given!(:user) { create(:user) }
    given!(:authorization) { create(:authorization, provider: 'twitter', uid: '12345', user: user) }

    scenario 'can sign in from twitter account' do
      visit root_path
      click_on 'Ask question'

      mock_twitter_hash
      click_on 'Sign in with Twitter'

      expect(current_path).to eq root_path
      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      expect(page).to have_content 'Завершить сессию'
    end
  end

  context 'invalid credentials' do
    scenario "can handle authentication error" do
      OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
      visit root_path
      click_on 'Ask question'
      click_on 'Sign in with Twitter'
      expect(page).to have_content('Could not authenticate you from Twitter because "Invalid credentials".')
    end
  end

end