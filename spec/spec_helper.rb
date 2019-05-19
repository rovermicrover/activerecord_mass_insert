# frozen_string_literal: true

$LOAD_PATH << File.expand_path('spec')

require 'bundler/setup'
Bundler.require(:default, :development)
require 'activerecord_mass_insert'

if Object.const_defined?('RSpec')
  require 'simplecov'
  SimpleCov.start
end

conn = PG::Connection.connect(dbname: 'postgres')

conn.exec('DROP DATABASE IF EXISTS activerecord_mass_insert')
conn.exec('CREATE DATABASE activerecord_mass_insert')

ActiveRecord::Base.establish_connection(
  adapter: :postgresql, database: 'activerecord_mass_insert'
)

require 'support/schema'
require 'support/dog'

Dir[File.join(__dir__, 'fixtures', '*.rb')].each { |file| require file }
