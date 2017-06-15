require 'rom/influxdb/dataset'
require 'rom/influxdb/relation'
require 'rom/influxdb/commands'

module ROM
  module InfluxDB
    class Gateway < ROM::Gateway
      adapter :influxdb

      attr_reader :datasets

      # InfluxDB gateway interface
      #
      # @overload connect(uri, options)
      #   Connects to database via uri passing options
      #
      #   @param [String,Symbol] uri connection URI
      #   @param [Hash] options connection options
      #
      # @example
      #   gateway = ROM::InfluxDB::Gateway.new('influxdb://localhost/rom',
      #     { username: 'foo', password: 'bar' })
      #
      # @api public
      def initialize(uri, options = {})
        @options = options
        @connection = connect(uri, options)
        @datasets = {}
      end

      # Return dataset with the given name
      #
      # @param [String] name a dataset name
      #
      # @return [Dataset]
      #
      # @api public
      def dataset(name)
        datasets[name] = Dataset.new(name, connection)
      end

      # Return dataset with the given name
      #
      # @param [String] name dataset name
      #
      # @return [Dataset]
      #
      # @api public
      def [](name)
        datasets.fetch(name)
      end

      # Check if dataset exists
      #
      # @param [String] name dataset name
      #
      # @api public
      def dataset?(name)
        exists_dataset?
      rescue ::InfluxDB::Error
        false
      end

      def command_namespace
        InfluxDB::Commands
      end

      private

      # Connect to database
      #
      # @return [Database::InfluxDB] a connection instance
      #
      # @api private
      def connect(uri, options)
        uri = URI.parse(uri)
        host = uri.host
        port = uri.port
        dbname = uri.path[1..-1]
        params = { host: host, port: port }.merge(options)
        ::InfluxDB::Client.new(dbname, params)
      end

      def exists_dataset?
        connection.query("SELECT * FROM #{name} LIMIT 1")
      end
    end
  end
end
