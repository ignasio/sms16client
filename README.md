# Sms16Client

Sms16Client is a gem that provides an interface for sms16.ru API.

## Usage

    sms16 = Sms16Client.new 'username', 'password'
    # or you can use Sms16Client::Client directly
    # Sms16Client::Client.new 'username', 'password'

    sms.get_balance
    # => "300"
    sms.send_message "hello world", "12345678900", "author"
    # => "12345678" # message_id
    sms.get_message_state "12345678"
    # => "send" # send, deliver & etc

## Installation

  gem install sms16client
