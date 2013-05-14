# dm-is-reflective [![Build Status](https://secure.travis-ci.org/godfat/dm-is-reflective.png?branch=master)](http://travis-ci.org/godfat/dm-is-reflective)

by Lin Jen-Shin ([godfat](http://godfat.org))

## LINKS:

* [github](https://github.com/godfat/dm-is-reflective)
* [rubygems](https://rubygems.org/gems/dm-is-reflective)
* [rdoc](http://rdoc.info/github/godfat/dm-is-reflective)

## DESCRIPTION:

DataMapper plugin that helps you manipulate an existing database.
It creates mappings between existing columns and model's properties.

## REQUIREMENTS:

* dm-core
* choose one: dm-sqlite-adapter, dm-postgres-adapter, dm-mysql-adapter

## INSTALLATION:

``` shell
gem install dm-is-reflective
```

``` ruby
gem 'dm-is-reflective',
  :git => 'git://github.com/godfat/dm-is-reflective.git',
  :submodules => true
```

## SYNOPSIS:

### Generating sources from a DATABASE_URI

We also have an executable to generate sources for you.

```
Usage: dm-is-reflective DATABASE_URI
  -s, --scope SCOPE       SCOPE where the models should go (default: Object)
  -o, --output DIRECTORY  DIRECTORY where the output goes (default: dm-is-reflective)
  -h, --help              Print this message
  -v, --version           Print the version
```

### API

``` ruby
require 'dm-is-reflective' # this would require 'dm-core'
dm = DataMapper.setup :default, 'sqlite::memory:'

class User
  include DataMapper::Resource
  is :reflective

  # map all, returning an array of properties indicating fields it mapped
  reflect /.*/  # e.g. => [#<Property:#<Class:0x18f89b8>:id>,
                #          #<Property:#<Class:0x18f89b8>:title>,
                #          #<Property:#<Class:0x18f89b8>:body>,
                #          #<Property:#<Class:0x18f89b8>:user_id>]

  # map all (with no argument at all)
  reflect

  # mapping for field name ended with _at, and started with salt_
  reflect /_at$/, /^salt_/

  # mapping id and email
  reflect :id, :email

  # mapping all fields with type String, and id
  reflect String, :id

  # mapping login, and all fields with type Integer
  reflect :login, Integer
end

# there's no guarantee of the order in storages array
dm.storages
# => ['users']

# there's no guarantee of the order in fields array
User.fields
# => [[:created_at,  DateTime, {:required => false}],
      [:email,       String,   {:required => false, :length => 255,
                                :default  => 'nospam@nospam.tw'}],
      [:id,          Serial,   {:required => true, :serial => true,
                                :key      => true}],
      [:salt_first,  String,   {:required => false, :length => 50}],
      [:salt_second, String,   {:required => false, :length => 50}]]

dm.fields('users').sort_by{ |field| field.first.to_s } ==
       User.fields.sort_by{ |field| field.first.to_s }
# => true

dm.storages_and_fields
# => {'users' => [[:id,          Serial,   {:required => true,
                                            :serial   => true,
                                            :key      => true}],
                  [:email,       String,   {:required => false,
                                            :default  =>
                                              'nospam@nospam.tw'}],
                  [:created_at,  DateTime, {:required => false}],
                  [:salt_first,  String,   {:required => false,
                                            :length   => 50}],
                  [:salt_second, String,   {:required => false,
                                            :length   => 50}]]}

# there's no guarantee of the order in returned array
dm.auto_genclass!
# => [DataMapper::Is::Reflective::User,
      DataMapper::Is::Reflective::SchemaInfo,
      DataMapper::Is::Reflective::Session]

# you can change the scope of generated models:
dm.auto_genclass! :scope => Object
# => [User, SchemaInfo, Session]

# you can generate classes for tables you specified only:
dm.auto_genclass! :scope => Object, :storages => /^phpbb_/
# => [PhpbbUser, PhpbbPost, PhpbbConfig]

# you can generate classes with String too:
dm.auto_genclass! :storages => ['users', 'config'], :scope => Object
# => [User, Config]

# you can generate a class only:
dm.auto_genclass! :storages => 'users'
# => [DataMapper::Is::Reflective::User]

# you can also generate the source from models:
puts User.to_source
```

## CONTRIBUTORS:

* Andrew Kreps (@onewheelskyward)
* Lin Jen-Shin (@godfat)

## LICENSE:

Apache License 2.0

Copyright (c) 2008-2013, Lin Jen-Shin (godfat)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
