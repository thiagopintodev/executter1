class EventMailer < ActionMailer::Base
  #default :from => "Executter <notifications@executter.com>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.event_mailer.followed.subject
  #
  def followed(follower_relationship)
    @user_follower, @user_followed = follower_relationship.user1, follower_relationship.user2
    subject = "#{@user_follower.username} agora esta seguindo voce"
    from = "Seguindo <notifications@executter.com>"
    mail :from => from, :to => @user_followed.email, :subject => subject
  end
end
