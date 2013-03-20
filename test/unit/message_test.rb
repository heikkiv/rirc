require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "create empty message" do
    m1 = Message.new
    m1.body = 'foo'
    m2 = Message.new
    m2.body = 'bar'
    assert m1.body == 'foo'
    assert m2.body == 'bar'
    assert m2.created > m1.created
  end

  test "create message with JSON" do
    m = Message.new(JSON.parse('{"body": "Hi"}'))
    assert m.body == 'Hi'
  end

  test "message body is html escaped" do
    m = Message.new @body => '<hi> hoi'
    assert_equal '', m.body
  end

  test "saving" do
    m = Message.new
    m.body = 'Hi <yammer>'
    m.sender = 'test_user'
    m.channel = 'test_channel'
    Message.save(m)
  end

  test "listing" do
    messages = Message.list('test_channel')
    messages.each do |message|
      assert message.body == 'Hi'
    end
  end

  test "list private message senders" do
    senders = Message.private_message_senders
    assert senders.length >= 0
    assert senders.include?('HeikkiV__')
  end

  test "mark links in body" do
    m = Message.new
    m.body = 'check out http://google.com fool'
    assert_equal "check out <a href='http://google.com'>http://google.com</a> fool", m.body_with_html_links
  end

  test "contains mention" do
    m = Message.new
    m.body = 'Hei heikkiv_'
    assert m.contains_mention
  end

end
