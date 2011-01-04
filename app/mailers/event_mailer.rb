class EventMailer < ActionMailer::Base
  #default :from => "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.event_mailer.followed.subject
  #
  def followed(follower_relationship)
    @user_follower, @user_followed = follower_relationship.user1, follower_relationship.user2
    subject = "@#{@user_follower.username} is following you"
    mail :to => @user_followed.email, :subject => subject
  end
end
