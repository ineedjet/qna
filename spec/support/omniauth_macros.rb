module OmniauthMacros

  # The mock_auth configuration allows you to set per-provider (or default)
  # authentication hashes to return during integration testing.

  def mock_facebook_hash
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
        {
          provider: 'facebook',
          uid: '123456',
          info: { email: 'test@email.com' }
        })
  end

  def mock_twitter_hash
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
        {
          provider: 'twitter',
          uid: '1235456'
        })
  end
end