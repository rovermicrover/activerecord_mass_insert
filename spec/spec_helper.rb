# frozen_string_literal: true

$LOAD_PATH << File.expand_path('spec')

require 'bundler/setup'
require 'pry'
require 'pg'
require 'active_record'

if Object.const_defined?('RSpec')
  require 'simplecov'
  SimpleCov.start
end

require 'activerecord/bulk_insert'

conn = PG::Connection.connect(dbname: 'postgres')

conn.exec('DROP DATABASE IF EXISTS activerecord_bulk_insert')
conn.exec('CREATE DATABASE activerecord_bulk_insert')

ActiveRecord::Base.establish_connection(
  adapter: :postgresql, database: 'activerecord_bulk_insert'
)

require 'support/schema'
require 'support/dog'

Dir[File.join(__dir__, 'fixtures', '*.rb')].each { |file| require file }
