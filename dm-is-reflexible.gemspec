# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dm-is-reflexible}
  s.version = "0.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lin Jen-Shin (aka godfat \347\234\237\345\270\270)"]
  s.date = %q{2009-06-21}
  s.description = %q{ DataMapper plugin that helps you manipulate an existing database.
 It creates mappings between existing columns and model's properties.}
  s.email = %q{godfat (XD) godfat.org}
  s.extra_rdoc_files = ["CHANGES", "LICENSE", "NOTICE", "README", "TODO", "dm-is-reflexible.gemspec"]
  s.files = ["CHANGES", "LICENSE", "NOTICE", "README", "Rakefile", "TODO", "dm-is-reflexible.gemspec", "lib/dm-is-reflexible.rb", "lib/dm-is-reflexible/is/adapters/abstract.rb", "lib/dm-is-reflexible/is/adapters/mysql_adapter.rb", "lib/dm-is-reflexible/is/adapters/postgres_adapter.rb", "lib/dm-is-reflexible/is/adapters/sqlite3_adapter.rb", "lib/dm-is-reflexible/is/reflexible.rb", "lib/dm-is-reflexible/is/version.rb", "lib/dm-is-reflexible/version.rb", "test/abstract.rb", "test/test_dm-is-reflexible.rb"]
  s.homepage = %q{http://github.com/godfat/dm-is-reflexible}
  s.rdoc_options = ["--charset=utf-8", "--inline-source", "--line-numbers", "--promiscuous", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{ludy}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{DataMapper plugin that helps you manipulate an existing database. It creates mappings between existing columns and model's properties.}
  s.test_files = ["test/test_dm-is-reflexible.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, [">= 0.10.0"])
      s.add_runtime_dependency(%q<extlib>, [">= 0.9.13"])
      s.add_development_dependency(%q<bones>, [">= 2.5.1"])
    else
      s.add_dependency(%q<dm-core>, [">= 0.10.0"])
      s.add_dependency(%q<extlib>, [">= 0.9.13"])
      s.add_dependency(%q<bones>, [">= 2.5.1"])
    end
  else
    s.add_dependency(%q<dm-core>, [">= 0.10.0"])
    s.add_dependency(%q<extlib>, [">= 0.9.13"])
    s.add_dependency(%q<bones>, [">= 2.5.1"])
  end
end
