require 'bundler/setup'
require 'pry'
require 'activerecord/bulk_insert'

conn = PG.connect(dbname: 'postgres')

conn.exec(
  <<-SQL
    DROP DATABASE IF EXISTS activerecord_bulk_insert;
    CREATE DATABASE activerecord_bulk_insert;
  SQL
)

ActiveRecord::Base.establish_connection adapter: :pg, database: "activerecord_bulk_insert"
load 'schema.rb'
load 'dog.rb'