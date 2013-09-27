
begin
  require "#{dir = File.dirname(__FILE__)}/task/gemgem"
rescue LoadError
  sh 'git submodule update --init'
  exec Gem.ruby, '-S', $PROGRAM_NAME, *ARGV
end

Gemgem.init(dir) do |s|
  require     'dm-is-reflective/version'
  s.name    = 'dm-is-reflective'
  s.version = DmIsReflective::VERSION

  %w[dm-core dm-do-adapter].each{ |g| s.add_runtime_dependency(g) }
  %w[dm-migrations
     dm-sqlite-adapter
     dm-mysql-adapter
     dm-postgres-adapter].each{ |g| s.add_development_dependency(g) }
end
