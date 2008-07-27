
Gem::Specification.new do |s|
  s.name = %q{dm-mapping}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lin Jen-Shin (a.k.a. godfat \347\234\237\345\270\270)"]
  s.date = %q{2008-07-27}
  s.description = %q{placeholder}
  s.email = %q{strip any number: 18god29fat7029 (at] godfat32 -dooot- 20org}
  s.extra_rdoc_files = ["CHANGES", "LICENSE", "NOTICE", "README", "tasks/ann.rake", "tasks/bones.rake", "tasks/gem.rake", "tasks/git.rake", "tasks/manifest.rake", "tasks/notes.rake", "tasks/post_load.rake", "tasks/rdoc.rake", "tasks/rubyforge.rake", "tasks/spec.rake", "tasks/svn.rake", "tasks/test.rake"]
  s.files = ["CHANGES", "LICENSE", "Manifest", "NOTICE", "README", "Rakefile", "lib/dm-mapping.rb", "lib/dm-mapping/sqlite3adapter.rb", "lib/dm-mapping/version.rb", "tasks/ann.rake", "tasks/bones.rake", "tasks/gem.rake", "tasks/git.rake", "tasks/manifest.rake", "tasks/notes.rake", "tasks/post_load.rake", "tasks/rdoc.rake", "tasks/rubyforge.rake", "tasks/setup.rb", "tasks/spec.rake", "tasks/svn.rake", "tasks/test.rake", "test/test_dm-mapping.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/godfat/dm-mapping}
  s.rdoc_options = ["--diagram", "--charset=utf-8", "--inline-source", "--line-numbers", "--promiscuous", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{ludy}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{placeholder}
  s.test_files = ["test/test_dm-mapping.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<dm-core>, [">= 0"])
    else
      s.add_dependency(%q<dm-core>, [">= 0"])
    end
  else
    s.add_dependency(%q<dm-core>, [">= 0"])
  end
end
