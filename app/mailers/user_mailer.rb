class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: 'So nice of you to join RailsFacebook...')
  end
end
