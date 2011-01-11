class EventMailer < ActionMailer::Base
  #default :from => "Executter <notifications@executter.com>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.event_mailer.followed.subject
  #
  def followed(user, followers_user)
    @user, @followers_user = user, followers_user
    subject = "#{@followers_user.length} pessoa(s) comecaram a te seguir"
    from = "Seguindo <notifications@executter.com>"
    mail :from => from, :to => @user.email, :subject => subject
  end
end
