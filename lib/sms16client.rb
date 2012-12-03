# encoding: utf-8

# stdlib
require 'builder'
require 'net/http'
require 'net/https'

# external dependency
require 'sax-machine'
require 'pry'

class Sms16Client
  Version = '0.0.3'

  def initialize(login, password)
    @client = Client.new(login, password)
  end

  def method_missing(method_name, *args, &block)
    return super unless @client.respond_to?(method_name)
    @client.send(method_name, *args, &block)
  end
  
  class Client < Struct.new(:login, :password)
    def get_balance
      query = ""
      
      xml = Builder::XmlMarkup.new(:target => query)
      xml.request {
        xml.security {
          xml.login(:value => login)
          xml.password(:value => password)
        }
      }

      return parse_response(execute_query(query, 'https://my.sms16.ru/xml/balance.php'))
    end

    def send_message(message, destination, source)
      query = ""

      xml = Builder::XmlMarkup.new(:target => query)
      xml.request {
        xml.security {
          xml.login(:value => login)
          xml.password(:value => password)
        }
        xml.message(:type => "sms") {
          xml.sender source
          xml.text message
          xml.abonent(:phone => destination, :number_sms => "1")
        }
      }

      return parse_response(execute_query(query, 'https://my.sms16.ru/xml/'))
    end

    def get_message_state(message_id)
      query = ""

      xml = Builder::XmlMarkup.new(:target => query)
      xml.request {
        xml.security {
          xml.login(:value => login)
          xml.password(:value => password)
        }
        xml.get_state {
          xml.id_sms message_id
        }
      }

      return parse_response(execute_query(query, 'https://my.sms16.ru/xml/state.php'))
    end

    private

    def execute_query(query, uri)
      url = URI.parse(uri)
      headers = {"Content-Type" => "text/xml"}
      request = Net::HTTP.new(url.host, url.port)
      request.use_ssl = true
      request.post(url.path, query, headers).body
    end

    def parse_response(response)
      binding.pry
    end
  end
end
