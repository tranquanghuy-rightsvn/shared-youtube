class Users::SessionsController < Devise::SessionsController
  def create
    return signin_for_user if User.find_by email: sign_in_params[:email]
      
    signup_for_user
  end

  private

  def signin_for_user
    self.resource = warden.authenticate(auth_options)

    if resource
      sign_in(resource_name, resource)
      
      redirect_to root_path
    else
      @error = "Wrong password!"
      respond_to do |format|
        format.js
      end
    end
  end

  def signup_for_user
    user = User.new(sign_in_params)

    if user.save
      sign_in(:user, user)

      redirect_to root_path
    else
      @error = user.errors.full_messages.first
      respond_to do |format|
        format.js
      end
    end
  end
end
