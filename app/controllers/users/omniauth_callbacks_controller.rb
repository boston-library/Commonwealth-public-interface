class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Bpluser::Users::OmniauthCallbacksController
end