# encoding: UTF-8

require 'rubygems'
require 'builder'
require 'net/http'
require 'net/https'
require 'uri'

module Sms16Client
	VERSION = '0.0.2'
	
	class Client
		attr_accessor :login, :password, :query
	
		def initialize(login, password)
			@login = login
			@password = password
			@query = String.new
		end
		
		def get_balance
		  @query = String.new
			xml = Builder::XmlMarkup.new(:target => @query)

			xml.request {
				xml.security {
					xml.login(:value => @login)
					xml.password(:value => @password)
				}
			}
			
			return execute_query(@query, 'https://my.sms16.ru/xml/balance.php')
		end
		
		def send_message(message, destination, source)
		  @query = String.new
			xml = Builder::XmlMarkup.new(:target => @query)

			xml.request {
				xml.message(:type => "sms") {
					xml.sender source.to_s
					xml.text message.to_s
					xml.abonent(:phone => destination.to_s, :number_sms => "1")
				}
				xml.security {
					xml.login(:value => @login)
					xml.password(:value => @password)
				}
			}
			
			return execute_query(@query, 'https://my.sms16.ru/xml/')
		end
		
		def get_message_state(message_id)
		  @query = String.new
			xml = Builder::XmlMarkup.new(:target => @query)
			
			xml.request {
				xml.security {
					xml.login(:value => @login)
					xml.password(:value => @password)
				}
				xml.get_state {
					xml.id_sms message_id.to_s
				}
			}
			
			return execute_query(@query, 'https://my.sms16.ru/xml/state.php')
		end
		
		private
		
			def execute_query(query, uri)
				url = URI.parse(uri)
				headers = {"Content-Type" => "text/xml"}
				
				request = Net::HTTP.new(url.host, url.port)
				request.use_ssl = true
				
				return request.post(url.path, query, headers).body
			end
	end
end
