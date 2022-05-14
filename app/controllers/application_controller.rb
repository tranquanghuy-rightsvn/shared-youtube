class ApplicationController < ActionController::Base
  def redirect_to_root_path
    redirect_to root_path
  end

  def authenticate_user!
    unless user_signed_in?
      redirect_to_root_path
    end
  end
end
