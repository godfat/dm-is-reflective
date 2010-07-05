# encoding: utf-8

begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

ensure_in_path 'lib'
proj = 'dm-is-reflective'
require "#{proj}/version"

Bones{
  version DataMapper::Is::Reflective::VERSION

  ruby_opts [''] # silence warning, too many in addressable and/or dm-core
  depend_on 'dm-core', :version => '>=1.0.0'

  %w[dm-migrations    dm-sqlite-adapter
     dm-mysql-adapter dm-postgres-adapter].each{ |lib|
       depend_on lib, :development => true, :version => '>=1.0.0'
     }

  name    proj
  url     "http://github.com/godfat/#{proj}"
  authors 'Lin Jen-Shin (aka godfat 真常)'
  email   'godfat (XD) godfat.org'

  history_file   'CHANGES'
   readme_file   'README'
   ignore_file   '.gitignore'
  rdoc.include   ['\w+']
}

CLEAN.include Dir['**/*.rbc']

task :default do
  Rake.application.options.show_task_pattern = /./
  Rake.application.display_tasks_and_comments
end
