Rails.application.routes.draw do

  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    omniauth_callbacks:  'omniauth_callbacks'
  }
  devise_scope :user do
    post 'auth/facebook' => "omniauth_callbacks#facebook_login"
  end

end
