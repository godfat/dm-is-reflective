
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dm-mapping}
  s.version = "0.7.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lin Jen-Shin (a.k.a. godfat \347\234\237\345\270\270)"]
  s.date = %q{2009-01-05}
  s.description = %q{DataMapper plugin that helps you manipulate an existing database. It creates mappings between existing columns and model's properties.}
  s.email = %q{godfat (XD) godfat.org}
  s.extra_rdoc_files = ["CHANGES", "LICENSE", "NOTICE", "README", "TODO", "dm-mapping.gemspec"]
  s.files = ["CHANGES", "LICENSE", "NOTICE", "README", "Rakefile", "TODO", "dm-mapping.gemspec", "lib/dm-mapping.rb", "lib/dm-mapping/adapters/abstract_adapter.rb", "lib/dm-mapping/adapters/mysql_adapter.rb", "lib/dm-mapping/adapters/postgres_adapter.rb", "lib/dm-mapping/adapters/sqlite3_adapter.rb", "lib/dm-mapping/model.rb", "lib/dm-mapping/type_map.rb", "lib/dm-mapping/version.rb", "test/abstract.rb", "test/test_dm-mapping.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/godfat/dm-mapping}
  s.rdoc_options = ["--diagram", "--charset=utf-8", "--inline-source", "--line-numbers", "--promiscuous", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{ludy}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{DataMapper plugin that helps you manipulate an existing database. It creates mappings between existing columns and model's properties.}
  s.test_files = ["test/test_dm-mapping.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, [">= 0.9.3"])
      s.add_runtime_dependency(%q<extlib>, [">= 0.9.3"])
      s.add_development_dependency(%q<bones>, [">= 2.2.0"])
    else
      s.add_dependency(%q<dm-core>, [">= 0.9.3"])
      s.add_dependency(%q<extlib>, [">= 0.9.3"])
      s.add_dependency(%q<bones>, [">= 2.2.0"])
    end
  else
    s.add_dependency(%q<dm-core>, [">= 0.9.3"])
    s.add_dependency(%q<extlib>, [">= 0.9.3"])
    s.add_dependency(%q<bones>, [">= 2.2.0"])
  end
end
