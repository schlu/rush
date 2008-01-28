module Rush
	class Box
		attr_reader :host

		def initialize(host)
			@host = host
		end

		def filesystem
			Rush::Entry.factory('/')
		end

		def [](key)
			filesystem[key]
		end

		def connection
			@connection ||= make_connection
		end

		def make_connection
			host == 'localhost' ? Rush::Connection::Local.new : Rush::Connection::Remote.new(host)
		end

		def write_file(full_path, contents)
			connection.write_file(full_path, contents)
		end
	end
end