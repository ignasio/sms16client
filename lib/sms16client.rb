# encoding: utf-8

$:.push File.expand_path(File.dirname(__FILE__) + "/../lib")

# stdlib
require 'net/http'
require 'net/https'

# external dependency
require 'builder'
require 'sax-machine'

# internal dependency
require 'sms16client/parser'

class Sms16Client
  Version = '0.0.3'

  def self.new(login, password)
    Client.new(login, password)
  end

  class Client
    attr_accessor :login, :password

    def initialize(login, password)
      @login = login
      @password = password
    end

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
      response = Response.parse(response)

      return error_response(response) if response.error? 
      return balance_response(response) if response.money?
      return information_response(response) if response.information?
      return state_response(response) if response.state?
    end

    def error_response(response)
      {
        :error => response.error
      }
    end

    def balance_response(response)
      {
        :money => {
          :currency => response.money.currency,
          :amount => response.money.text
        },
        :sms => [
          {
            :area => response.sms[0].area,
            :amount => response.sms[0].text
          },
          {
            :area => response.sms[1].area,
            :amount => response.sms[1].text
          }
        ] 
      }
    end

    def information_response(response)
      {
        :information => {
          :number_sms => response.information.number_sms,
          :id_sms => response.information.id_sms,
          :parts => response.information.parts,
          :response => response.information.text
        }
      }
    end

    def state_response(response)
      {
        :state => {
          :id_sms => response.state.id_sms,
          :time => response.state.time,
          :err => response.state.err,
          :response => response.state.text
        }
      }
    end
  end
end
