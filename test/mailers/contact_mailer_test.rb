require 'test_helper'

class ContactMailerTest < ActionMailer::TestCase
  test "send" do
    mail = ContactMailer.send
    assert_equal "Send", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "send_confirmation" do
    mail = ContactMailer.send_confirmation
    assert_equal "Send confirmation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
