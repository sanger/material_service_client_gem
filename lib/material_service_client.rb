require "material_service_client/version"
require 'faraday'
require 'json'

module MaterialServiceClient
	module Material
		def self.post(data)
			conn = MaterialServiceClient::get_connection
			JSON.parse(conn.post('/materials', data.to_json).body)
		end

		def self.put(data)
			uuid = data[:uuid]
			data_to_send = data.reject{|k,v| k.to_sym == :uuid}

			conn = MaterialServiceClient::get_connection
			JSON.parse(conn.put('/materials/'+uuid, data_to_send.to_json).body)
		end

		def self.get(uuid)
			return nil if uuid.nil?
			conn = MaterialServiceClient::get_connection
			JSON.parse(conn.get('/materials/'+uuid).body)
		end

		def self.valid?(uuids)
			conn = MaterialServiceClient::get_connection
			data = { materials: uuids }

			response = conn.post('/materials/validate', data.to_json)
			response.body == 'ok'
		end

		def self.delete(uuid)
			return nil if uuid.nil?
			conn = MaterialServiceClient::get_connection
			JSON.parse(conn.delete('/materials/'+uuid).body)
		end
	end

	module Container
		def self.post(data)
			conn = MaterialServiceClient::get_connection
			JSON.parse(conn.post('/containers', data.to_json).body)
		end

		def self.put(data)
			uuid = data[:uuid]
			data_to_send = data.reject{|k,v| k.to_sym == :uuid}

			conn = MaterialServiceClient::get_connection
			JSON.parse(conn.put('/containers/'+uuid, data_to_send.to_json).body)
		end

		def self.get(uuid)
			return nil if uuid.nil?
			conn = MaterialServiceClient::get_connection
			JSON.parse(conn.get('/containers/'+uuid).body)
		end

		def self.delete(uuid)
			return nil if uuid.nil?
			conn = MaterialServiceClient::get_connection
			conn.delete('/containers/'+uuid)
		end
	end

	private

	def self.get_connection
		conn = Faraday.new(:url => ENV['MATERIALS_URL']) do |faraday|
		  # faraday.use ZipkinTracer::FaradayHandler, 'eve'
		  faraday.proxy ENV['MATERIALS_URL']
		  faraday.request  :url_encoded
		  faraday.response :logger
		  faraday.adapter  Faraday.default_adapter
		end
		conn.headers = {'Content-Type' => 'application/json'}
		conn
	end

end
