require 'influxdb'

require 'rom'
require 'rom/influxdb/version'
require 'rom/influxdb/relation'
require 'rom/influxdb/gateway'

ROM.register_adapter(:influxdb, ROM::InfluxDB)
