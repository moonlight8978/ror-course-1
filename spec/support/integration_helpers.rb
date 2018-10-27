module IntegrationHelpers
  def sign_in_as(email, password = '1111')
    login_params = { email: email, password: password }
    post sign_in_path, params: { user: login_params }
  end
end
