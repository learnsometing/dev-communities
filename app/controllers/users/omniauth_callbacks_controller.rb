# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      session['devise.github_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end

  # GET|POST /resource/auth/twitter
  def passthru
    super
  end

  # GET|POST /users/auth/twitter/callback
  def failure
    redirect_to root_path
  end

  # protected

  # The path used when OmniAuth fails
  def after_omniauth_failure_path_for(scope)
    super(scope)
  end
end
