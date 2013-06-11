# Sms16Client

Sms16Client is a gem that provides an interface for sms16.ru API.

## Usage

```ruby
require 'sms16client'

sms16 = Sms16Client.new 'username', 'password'

sms16.get_balance
sms16.send_message "hello world", "12345678900", "author"
sms16.get_message_state "111"
```

## Installation

    gem install sms16client

## Changelog

    0.1.1 - Minor release that includes:
      - Fix bug in #get_balance method accordingly to sms16 API changes
      - Update README

    0.1.0 - Minor release that includes:
      - Remove obsolete class Client
      - Change method responses from original sms16.ru api xml's to our own hashes
      - Update README, add LICENSE and specs
