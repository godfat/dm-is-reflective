# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "dm-is-reflective"
  s.version = "1.0.1.rc"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lin Jen-Shin (godfat)"]
  s.date = "2012-05-16"
  s.description = "DataMapper plugin that helps you manipulate an existing database.\nIt creates mappings between existing columns and model's properties."
  s.email = ["godfat (XD) godfat.org"]
  s.files = [
  ".gitignore",
  ".gitmodules",
  "CHANGES.md",
  "Gemfile",
  "LICENSE",
  "README.md",
  "Rakefile",
  "TODO.md",
  "dm-is-reflective.gemspec",
  "lib/dm-is-reflective.rb",
  "lib/dm-is-reflective/is/adapters/data_objects_adapter.rb",
  "lib/dm-is-reflective/is/adapters/mysql_adapter.rb",
  "lib/dm-is-reflective/is/adapters/postgres_adapter.rb",
  "lib/dm-is-reflective/is/adapters/sqlite_adapter.rb",
  "lib/dm-is-reflective/is/reflective.rb",
  "lib/dm-is-reflective/is/version.rb",
  "lib/dm-is-reflective/version.rb",
  "task/.gitignore",
  "task/gemgem.rb",
  "test/abstract.rb",
  "test/setup_db.sh",
  "test/test_dm-is-reflective.rb"]
  s.homepage = "https://github.com/godfat/dm-is-reflective"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "DataMapper plugin that helps you manipulate an existing database."
  s.test_files = ["test/test_dm-is-reflective.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

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
