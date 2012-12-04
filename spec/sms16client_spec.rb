# encoding: utf-8

require 'fakeweb'

$:.push File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'sms16client'

describe Sms16Client do
  before do
    @sms16 = Sms16Client.new 'test', 'test'
  end

  it "incorrect credentials" do
    FakeWeb.register_uri(
      :post, 'https://my.sms16.ru/xml/balance.php',
      :body => "<?xml version=\"1.0\" encoding=\"utf-8\"?><response><error>Неправильный логин или пароль</error></response>")

    @sms16.get_balance[:error].should == "Неправильный логин или пароль"
  end

  it "balance" do
    FakeWeb.register_uri(
      :post, 'https://my.sms16.ru/xml/balance.php',
      :body => "<?xml version=\"1.0\" encoding=\"utf-8\"?><response><money currency=\"RUR\">3924.9</money><sms area=\"Россия\">26166</sms><sms area=\"Украина\">0</sms></response>")

    response = @sms16.get_balance

    response[:money][:currency].should == "RUR"
    response[:money][:amount].should == "3924.9"
    response[:sms][0][:area].should == "Россия"
    response[:sms][0][:amount].should == "26166"
  end

  it "send message" do
    FakeWeb.register_uri(
      :post, 'https://my.sms16.ru/xml/',
      :body => "<?xml version=\"1.0\" encoding=\"utf-8\"?><response><information number_sms=\"1\" id_sms=\"111\" parts=\"1\">send</information></response>")

    response = @sms16.send_message('test message', 'phone number', 'author')

    response[:information][:number_sms].should == "1"
    response[:information][:id_sms].should == "111"
    response[:information][:parts].should == "1"
    response[:information][:response].should == "send"
  end

  it "get message state" do
    FakeWeb.register_uri(
      :post, 'https://my.sms16.ru/xml/state.php',
      :body => "<?xml version=\"1.0\" encoding=\"utf-8\"?><response><state id_sms=\"111\" time=\"2012-12-04 05:20:19\" err=\"000\">deliver</state></response>")

    response = @sms16.get_message_state('111')

    response[:state][:id_sms].should == "111"
    response[:state][:time].should == "2012-12-04 05:20:19"
    response[:state][:err].should == "000"
    response[:state][:response].should == "deliver"
  end
end
