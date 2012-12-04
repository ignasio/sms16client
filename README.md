# Sms16Client

Sms16Client is a gem that provides an interface for sms16.ru API.

## Usage

```ruby
sms16 = Sms16Client.new 'username', 'password'
# or you can use Sms16Client::Client directly
# Sms16Client::Client.new 'username', 'password'

sms16.get_balance
# => {:money=>{:currency=>"RUR", :amount=>"3924.45"}, :sms=>[{:area=>"Россия", :amount=>"26163"}, {:area=>"Украина", :amount=>"0"}]}
sms16.send_message "hello world", "12345678900", "author"
# => {:information=>{:number_sms=>"1", :id_sms=>"111", :parts=>"1", :response=>"send"}}
sms16.get_message_state "111"
# => {:state=>{:id_sms=>"111", :time=>"2012-12-04 05:39:36", :err=>"000", :response=>"deliver"}}
```

## Installation

    gem install sms16client
