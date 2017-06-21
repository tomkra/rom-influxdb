require 'equalizer'

module ROM
  module InfluxDB
    class Dataset
      include ::Equalizer.new(:name, :connection)

      attr_reader :name, :connection, :tags, :values

      def initialize(name, connection)
        @name = name.to_s
        @connection = connection
        @data = nil
        @tags = nil
        @values = nil
      end

      def each(&block)
        with_set { |set| set.each(&block) }
      end

      def insert(object)
        connection.write_point(name, object)
      end
      alias_method :<<, :insert

      def where(query)
        @data = connection.query("SELECT * FROM #{name} WHERE #{query}").first

        distribute
      end

      def query(what = '*')
        @data = connection.query("SELECT #{what} FROM #{name}").first

        distribute
      end

      def limit(limit)
        @data = connection.query("SELECT * FROM #{name} ORDER BY time DESC LIMIT #{limit}")

        distribute
      end

      def count
        result = query('COUNT(*)').first

        result['count_a']
      end

      def to_a
        @values.to_a if @values
      end
      alias_method :all, :to_a

      private

      def with_set
        yield(query)
      end

      def distribute
        if @data
          @tags = @data['tags']
          @values = @data['values']

          @values
        end
      end
    end
  end
end
