# encoding: utf-8

require "#{dir = File.dirname(__FILE__)}/task/gemgem"
Gemgem.dir = dir

($LOAD_PATH << File.expand_path("#{Gemgem.dir}/lib" )).uniq!

desc 'Generate gemspec'
task 'gem:spec' do
  Gemgem.spec = Gemgem.create do |s|
    require     'dm-is-reflective/version'
    s.name    = 'dm-is-reflective'
    s.version = DataMapper::Is::Reflective::VERSION

    %w[dm-core dm-do-adapter].each{ |g| s.add_runtime_dependency(g) }
    %w[dm-migrations
       dm-sqlite-adapter
       dm-mysql-adapter
       dm-postgres-adapter].each{ |g| s.add_development_dependency(g) }
  end

  Gemgem.write
end

desc 'auto_migrate database'
task 'auto_migrate' do
  require 'dm-migrations'
  require './test/abstract'
  require './test/test_dm-is-reflective'
  include Abstract
  [:SqliteTest, :PostgresTest, :MysqlTest].each do |db|
    next unless Object.const_defined?(db)
    Object.const_get(db).setup_data_mapper
    [User, Comment, SuperUser].each(&:auto_migrate!)
  end
end
