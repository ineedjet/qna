module ControllerHelpers
  def sign_in_the_user(user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
  end
end