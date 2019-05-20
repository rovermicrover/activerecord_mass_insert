# frozen_string_literal: true

$LOAD_PATH << File.expand_path('spec')

if Object.const_defined?('RSpec')
  require 'simplecov'
  SimpleCov.start
end

require 'bundler/setup'
Bundler.require(:default, :development)

conn = PG::Connection.connect(
  host: ENV['TEST_POSTGRESQL_HOST'], port: ENV['TEST_POSTGRESQL_PORT'],
  user: ENV['TEST_POSTGRESQL_USER'], dbname: 'postgres'
)

conn.exec('DROP DATABASE IF EXISTS activerecord_mass_insert')
conn.exec('CREATE DATABASE activerecord_mass_insert')

ActiveRecord::Base.establish_connection(
  adapter: :postgresql, host: ENV['TEST_POSTGRESQL_HOST'], port: ENV['TEST_POSTGRESQL_PORT'],
  user: ENV['TEST_POSTGRESQL_USER'], database: 'activerecord_mass_insert'
)

require 'support/schema'
require 'support/dog'

Dir[File.join(__dir__, 'fixtures', '*.rb')].each { |file| require file }
