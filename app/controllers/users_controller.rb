class UsersController < ApplicationController
  def index
  end

  def show
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :image, :email)
  end

end
