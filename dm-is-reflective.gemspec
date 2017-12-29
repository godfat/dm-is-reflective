# -*- encoding: utf-8 -*-
# stub: dm-is-reflective 1.3.1 ruby lib

Gem::Specification.new do |s|
  s.name = "dm-is-reflective".freeze
  s.version = "1.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Lin Jen-Shin (godfat)".freeze]
  s.date = "2017-12-29"
  s.description = "DataMapper plugin that helps you manipulate an existing database.\nIt creates mappings between existing columns and model's properties.".freeze
  s.email = ["godfat (XD) godfat.org".freeze]
  s.executables = ["dm-is-reflective".freeze]
  s.files = [
  ".gitignore".freeze,
  ".gitmodules".freeze,
  ".travis.yml".freeze,
  "CHANGES.md".freeze,
  "Gemfile".freeze,
  "LICENSE".freeze,
  "README.md".freeze,
  "Rakefile".freeze,
  "TODO.md".freeze,
  "bin/dm-is-reflective".freeze,
  "dm-is-reflective.gemspec".freeze,
  "lib/dm-is-reflective.rb".freeze,
  "lib/dm-is-reflective/adapters/data_objects_adapter.rb".freeze,
  "lib/dm-is-reflective/adapters/mysql_adapter.rb".freeze,
  "lib/dm-is-reflective/adapters/postgres_adapter.rb".freeze,
  "lib/dm-is-reflective/adapters/sqlite_adapter.rb".freeze,
  "lib/dm-is-reflective/reflective.rb".freeze,
  "lib/dm-is-reflective/runner.rb".freeze,
  "lib/dm-is-reflective/test.rb".freeze,
  "lib/dm-is-reflective/version.rb".freeze,
  "task/README.md".freeze,
  "task/gemgem.rb".freeze,
  "test/setup_db.sh".freeze,
  "test/test_mysql.rb".freeze,
  "test/test_postgres.rb".freeze,
  "test/test_sqlite.rb".freeze,
  "test/test_to_source.rb".freeze]
  s.homepage = "https://github.com/godfat/dm-is-reflective".freeze
  s.licenses = ["Apache License 2.0".freeze]
  s.rubygems_version = "2.7.3".freeze
  s.summary = "DataMapper plugin that helps you manipulate an existing database.".freeze
  s.test_files = [
  "test/test_mysql.rb".freeze,
  "test/test_postgres.rb".freeze,
  "test/test_sqlite.rb".freeze,
  "test/test_to_source.rb".freeze]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<dm-do-adapter>.freeze, [">= 0"])
      s.add_development_dependency(%q<dm-migrations>.freeze, [">= 0"])
      s.add_development_dependency(%q<dm-sqlite-adapter>.freeze, [">= 0"])
      s.add_development_dependency(%q<dm-mysql-adapter>.freeze, [">= 0"])
      s.add_development_dependency(%q<dm-postgres-adapter>.freeze, [">= 0"])
    else
      s.add_dependency(%q<dm-core>.freeze, [">= 0"])
      s.add_dependency(%q<dm-do-adapter>.freeze, [">= 0"])
      s.add_dependency(%q<dm-migrations>.freeze, [">= 0"])
      s.add_dependency(%q<dm-sqlite-adapter>.freeze, [">= 0"])
      s.add_dependency(%q<dm-mysql-adapter>.freeze, [">= 0"])
      s.add_dependency(%q<dm-postgres-adapter>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<dm-core>.freeze, [">= 0"])
    s.add_dependency(%q<dm-do-adapter>.freeze, [">= 0"])
    s.add_dependency(%q<dm-migrations>.freeze, [">= 0"])
    s.add_dependency(%q<dm-sqlite-adapter>.freeze, [">= 0"])
    s.add_dependency(%q<dm-mysql-adapter>.freeze, [">= 0"])
    s.add_dependency(%q<dm-postgres-adapter>.freeze, [">= 0"])
  end
end
