class Foo < ActionMailer::Base
  default :from => "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.foo.bar.subject
  #
  def bar(to="to@example.org")
    @greeting = "Hi"

    mail :to => to
  end
end
