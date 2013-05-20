# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "dm-is-reflective"
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lin Jen-Shin (godfat)"]
  s.date = "2013-05-20"
  s.description = "DataMapper plugin that helps you manipulate an existing database.\nIt creates mappings between existing columns and model's properties."
  s.email = ["godfat (XD) godfat.org"]
  s.executables = ["dm-is-reflective"]
  s.files = [
  ".gitignore",
  ".gitmodules",
  ".travis.yml",
  "CHANGES.md",
  "Gemfile",
  "LICENSE",
  "README.md",
  "Rakefile",
  "TODO.md",
  "bin/dm-is-reflective",
  "dm-is-reflective.gemspec",
  "lib/dm-is-reflective.rb",
  "lib/dm-is-reflective/adapters/data_objects_adapter.rb",
  "lib/dm-is-reflective/adapters/mysql_adapter.rb",
  "lib/dm-is-reflective/adapters/postgres_adapter.rb",
  "lib/dm-is-reflective/adapters/sqlite_adapter.rb",
  "lib/dm-is-reflective/reflective.rb",
  "lib/dm-is-reflective/runner.rb",
  "lib/dm-is-reflective/test.rb",
  "lib/dm-is-reflective/version.rb",
  "task/.gitignore",
  "task/gemgem.rb",
  "test/setup_db.sh",
  "test/test_mysql.rb",
  "test/test_postgres.rb",
  "test/test_sqlite.rb",
  "test/test_to_source.rb"]
  s.homepage = "https://github.com/godfat/dm-is-reflective"
  s.licenses = ["Apache License 2.0"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "DataMapper plugin that helps you manipulate an existing database."
  s.test_files = [
  "test/test_mysql.rb",
  "test/test_postgres.rb",
  "test/test_sqlite.rb",
  "test/test_to_source.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, [">= 0"])
      s.add_runtime_dependency(%q<dm-do-adapter>, [">= 0"])
      s.add_development_dependency(%q<dm-migrations>, [">= 0"])
      s.add_development_dependency(%q<dm-sqlite-adapter>, [">= 0"])
      s.add_development_dependency(%q<dm-mysql-adapter>, [">= 0"])
      s.add_development_dependency(%q<dm-postgres-adapter>, [">= 0"])
    else
      s.add_dependency(%q<dm-core>, [">= 0"])
      s.add_dependency(%q<dm-do-adapter>, [">= 0"])
      s.add_dependency(%q<dm-migrations>, [">= 0"])
      s.add_dependency(%q<dm-sqlite-adapter>, [">= 0"])
      s.add_dependency(%q<dm-mysql-adapter>, [">= 0"])
      s.add_dependency(%q<dm-postgres-adapter>, [">= 0"])
    end
  else
    s.add_dependency(%q<dm-core>, [">= 0"])
    s.add_dependency(%q<dm-do-adapter>, [">= 0"])
    s.add_dependency(%q<dm-migrations>, [">= 0"])
    s.add_dependency(%q<dm-sqlite-adapter>, [">= 0"])
    s.add_dependency(%q<dm-mysql-adapter>, [">= 0"])
    s.add_dependency(%q<dm-postgres-adapter>, [">= 0"])
  end
end
