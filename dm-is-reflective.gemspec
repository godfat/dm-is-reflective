# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dm-is-reflective}
  s.version = "0.9.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lin Jen-Shin (aka godfat 真常)"]
  s.date = %q{2010-07-05}
  s.description = %q{ DataMapper plugin that helps you manipulate an existing database.
 It creates mappings between existing columns and model's properties.}
  s.email = %q{godfat (XD) godfat.org}
  s.extra_rdoc_files = ["CHANGES", "LICENSE", "NOTICE", "README", "Rakefile", "TODO", "dm-is-reflective.gemspec", "test/setup_db.sh"]
  s.files = ["CHANGES", "LICENSE", "NOTICE", "README", "Rakefile", "TODO", "dm-is-reflective.gemspec", "lib/dm-is-reflective.rb", "lib/dm-is-reflective/is/adapters/abstract_adapter.rb", "lib/dm-is-reflective/is/adapters/data_objects_adapter.rb", "lib/dm-is-reflective/is/adapters/mysql_adapter.rb", "lib/dm-is-reflective/is/adapters/postgres_adapter.rb", "lib/dm-is-reflective/is/adapters/sqlite_adapter.rb", "lib/dm-is-reflective/is/reflective.rb", "lib/dm-is-reflective/is/version.rb", "lib/dm-is-reflective/version.rb", "test/abstract.rb", "test/setup_db.sh", "test/test_dm-is-reflective.rb"]
  s.homepage = %q{http://github.com/godfat/dm-is-reflective}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{dm-is-reflective}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{DataMapper plugin that helps you manipulate an existing database}
  s.test_files = ["test/test_dm-is-reflective.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, [">= 1.0.0"])
      s.add_development_dependency(%q<dm-migrations>, [">= 1.0.0"])
      s.add_development_dependency(%q<dm-sqlite-adapter>, [">= 1.0.0"])
      s.add_development_dependency(%q<dm-mysql-adapter>, [">= 1.0.0"])
      s.add_development_dependency(%q<dm-postgres-adapter>, [">= 1.0.0"])
      s.add_development_dependency(%q<bones>, [">= 3.4.7"])
    else
      s.add_dependency(%q<dm-core>, [">= 1.0.0"])
      s.add_dependency(%q<dm-migrations>, [">= 1.0.0"])
      s.add_dependency(%q<dm-sqlite-adapter>, [">= 1.0.0"])
      s.add_dependency(%q<dm-mysql-adapter>, [">= 1.0.0"])
      s.add_dependency(%q<dm-postgres-adapter>, [">= 1.0.0"])
      s.add_dependency(%q<bones>, [">= 3.4.7"])
    end
  else
    s.add_dependency(%q<dm-core>, [">= 1.0.0"])
    s.add_dependency(%q<dm-migrations>, [">= 1.0.0"])
    s.add_dependency(%q<dm-sqlite-adapter>, [">= 1.0.0"])
    s.add_dependency(%q<dm-mysql-adapter>, [">= 1.0.0"])
    s.add_dependency(%q<dm-postgres-adapter>, [">= 1.0.0"])
    s.add_dependency(%q<bones>, [">= 3.4.7"])
  end
end
