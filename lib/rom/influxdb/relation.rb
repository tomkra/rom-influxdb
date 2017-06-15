module ROM
  module InfluxDB
    class Relation < ROM::Relation
      adapter :influxdb

      forward :query, :where, :insert
    end
  end
end
