# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dm-is-reflective}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Lin Jen-Shin (godfat)}]
  s.date = %q{2011-06-16}
  s.description = %q{DataMapper plugin that helps you manipulate an existing database. It creates mappings between existing columns and model's properties.}
  s.email = [%q{godfat (XD) godfat.org}]
  s.extra_rdoc_files = [
  %q{CHANGES},
  %q{CONTRIBUTORS},
  %q{LICENSE},
  %q{TODO}]
  s.files = [
  %q{.gitignore},
  %q{.gitmodules},
  %q{CHANGES},
  %q{Gemfile},
  %q{LICENSE},
  %q{NOTICE},
  %q{README},
  %q{README.rdoc},
  %q{Rakefile},
  %q{TODO},
  %q{dm-is-reflective.gemspec},
  %q{lib/dm-is-reflective.rb},
  %q{lib/dm-is-reflective/is/adapters/data_objects_adapter.rb},
  %q{lib/dm-is-reflective/is/adapters/mysql_adapter.rb},
  %q{lib/dm-is-reflective/is/adapters/postgres_adapter.rb},
  %q{lib/dm-is-reflective/is/adapters/sqlite_adapter.rb},
  %q{lib/dm-is-reflective/is/reflective.rb},
  %q{lib/dm-is-reflective/is/version.rb},
  %q{lib/dm-is-reflective/version.rb},
  %q{task/gemgem.rb},
  %q{test/abstract.rb},
  %q{test/setup_db.sh},
  %q{test/test_dm-is-reflective.rb},
  %q{CONTRIBUTORS}]
  s.homepage = %q{https://github.com/godfat/dm-is-reflective}
  s.rdoc_options = [
  %q{--main},
  %q{README}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{DataMapper plugin that helps you manipulate an existing database. It creates mappings between existing columns and model's properties.}
  s.test_files = [%q{test/test_dm-is-reflective.rb}]

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
