module ROM
  module InfluxDB
    class Relation < ROM::Relation
      adapter :influxdb

      forward :query, :where, :insert, :<<

      def count
        dataset.count
      end
    end
  end
end
