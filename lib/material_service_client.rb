require "material_service_client/version"
require 'faraday'
require 'json'


module MaterialServiceClient

	class MissingSite < StandardError; end

	def self.site=(site)
		@site = site
	end

	def self.site
		@site || ENV['MATERIALS_URL']
	end

	class Base
		def self.connection
			url = MaterialServiceClient.site

			raise MissingSite.new, 'site must be set on MaterialServiceClient before any requests can be made' if url.nil?

			Faraday.new(:url => url, :headers => {'Content-Type' => 'application/json'}) do |faraday|
			  faraday.use ZipkinTracer::FaradayHandler, 'eve'
			  faraday.proxy url
			  faraday.request  :url_encoded
			  faraday.response :logger
			  faraday.adapter  Faraday.default_adapter
			end
		end
	end

	class Material < Base
		def self.post(data)
			JSON.parse(connection.post('/materials', data.to_json).body)
		end

		def self.put(data)
			uuid = data[:uuid]
			data_to_send = data.reject{|k,v| k.to_sym == :uuid}

			JSON.parse(connection.put('/materials/'+uuid, data_to_send.to_json).body)
		end

		def self.get(uuid)
			return nil if uuid.nil?
			JSON.parse(connection.get('/materials/'+uuid).body)
		end

		def self.valid?(uuids)
			data = { materials: uuids }

			response = connection.post('/materials/validate', data.to_json)
			response.body == 'ok'
		end

		def self.delete(uuid)
			return nil if uuid.nil?
			connection.delete('/materials/'+uuid)
    end
	end

	class Container < Base
		def self.post(data)
			JSON.parse(connection.post('/containers', data.to_json).body)
		end

		def self.put(data)
			uuid = data[:uuid]
			data_to_send = data.reject{|k,v| k.to_sym == :uuid}

			JSON.parse(connection.put('/containers/'+uuid, data_to_send.to_json).body)
		end

		def self.with_criteria(criteria)
			data = '?'+criteria.map do |k, value|
				"#{k.to_s}=#{value.to_json}"
			end.join('&')

			JSON.parse(connection.get('/containers'+ data).body)
		end

		def self.get(uuid)
			return nil if uuid.nil?
			JSON.parse(connection.get('/containers/'+uuid).body)
		end

		def self.delete(uuid)
			return nil if uuid.nil?
			connection.delete('/containers/'+uuid)
		end
	end

end
