module AuthenticationTestHelpers
  # User login. Accepts user object or fixture name
  def login_as(user)
    user = user.is_a?(User) ? user : users(user)
    session[:auth_token] = user.email
    user
  end

  def logout
    session[:auth_token] = nil
    session
  end
end
