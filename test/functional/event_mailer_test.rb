require 'test_helper'

class EventMailerTest < ActionMailer::TestCase
  test "followed" do
    mail = EventMailer.followed
    assert_equal "Followed", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
