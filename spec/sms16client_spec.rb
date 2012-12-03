$:.push File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'sms16client'

describe Sms16Client do
  it "should instantiate a client using Sms16Client class" do
    sms16 = Sms16Client.new 'test', 'test'
    sms16.class.should == Sms16Client::Client
  end
end
