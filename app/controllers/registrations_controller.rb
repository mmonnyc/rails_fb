class RegistrationsController < Devise::RegistrationsController
  def create
    super
    if @user.persisted?
      puts 'made it here'
      UserMailer.with(user: @user).welcome_email.deliver_now
    end
  end
end