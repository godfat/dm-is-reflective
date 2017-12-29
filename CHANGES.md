# CHANGES

## dm-is-reflective 1.3.2 -- 2017-12-29

* Prefix an underscore whenever the property begins with a number, which
  cannot be used as a method name. See:
  [#9](https://github.com/godfat/dm-is-reflective/pull/9)
  Thanks Mischa Molhoek (@mmolhoek)
* Don't create the model for PostgreSQL views. See:
  [#10](https://github.com/godfat/dm-is-reflective/pull/10)
  Thanks @philfine

## dm-is-reflective 1.3.1, 2013-05-22

* Introduce `indices` method which would return all indices in the storage.

## dm-is-reflective 1.3.0, 2013-05-20

* Warn instead of raising a TypeError if a datatype cannot be found.
  We fallback to use String.
* Now it works for multiple composite keys.
* If there's no key defined, it would pick the first unique index as the key.
* If a field name is conflicted, it would try to resolve it by appending a
  underscore to the field name.

## dm-is-reflective 1.2.0, 2013-05-14

* We got a bunch of internal renaming.
* Added DataMapper::Resource#to_source.
* Added an executable which generates sources for you.
* Fixed MySQL issues with setting up with a hash rather than URI.
* Fixed SQLite issues without loading dm-migrations.

## dm-is-reflective 1.1.0, 2013-01-11

* The need for dm-migrations is now removed.
* Added a few more datatypes. Thanks @onewheelskyward
* Tested against dm-core 1.2.0.

## dm-is-reflective 1.0.1, 2012-05-16

* allow_nil is more close to db's semantics, not required. Thanks miaout17.
  `:allow_nil` allows empty value, but `:required` does not. So here we
  always use `:allow_nil` to match db's semantics.

## dm-is-reflective 1.0.0, 2011-06-16

* updated against dm-core 1.1.0

## dm-is-reflective 0.9.0, 2010-07-05

* adapted to dm-core 1.0.0
* reanmed AbstractAdapter to DataObjectsAdapter

## dm-is-reflective 0.8.0, 2009-09-16

* require dm-core 0.10.0 and above now
* Serial would map to Serial not Integer now
* no more type_map now
* no more Extlib::Hook to load adapter

## dm-mapping 0.7.1, never released as a gem

don't open module Migration and edit it, instead, use include, more see:

* added DataMapper::Mapping::AbstractAdapter
* added DataMapper::Mapping::Sqlite3Adapter
* added DataMapper::Mapping::MysqlAdapter
* added DataMapper::Mapping::PostgresAdapter
* each adapter was included in related adapter in DataMapper.
* Model#fields now accept repository name as argument

there's differences between adapters,
Sqlite3 added default => 'UL' in Boolean type,
Mysql can't tell whether it's a Boolean or Tinyint,
and Postgres is fine. see test/abstract.rb: super_user_fields for detail.

## dm-mapping 0.7.0, 2008-09-01

* feature added

  - added postgres support.

* bug fixed

  - fixed key mapping in mysql adapter. PRI and MUL are all keys.
  - use DM::Text.size as default text size in sqlite3.

## dm-mapping 0.6.2, 2008-08-30

* mapping more data types for mysql.
* don't map TINYINT to TrueClass with mysql, skip it in type_map.

## dm-mapping 0.6.1, 2008-08-22

* gem 'dm-core', '>=0.9.3' instead of '=0.9.3'

## dm-mapping 0.6.0, 2008-08-16

* mapping returns an array of properties indicating fields it mapped.
* performance boosted by refactored mapping implementation.
* changed the way using auto_genclass!, now accepts args like mapping!
* changed fields to return field name with Symbol instead of String.
  this would make it be more consistent with DataMapper.
* storage names remain String.
* added more mysql data type to map
* use Extlib::Hook to setup dm-mapping instead of stupid alias_method.
* removed ensure_require in model. always setup DataMapper before define model.

## dm-mapping 0.5.0, 2008-08-14

* feature added

  - added mysql support.
  - reflect size 65535 in TEXT for sqlite3.

* bug fixed

  - reflect VARCHAR(size) instead of default size in sqlite3.

* misc

  - renamed sqlite3adapter to sqlite3_adapter.

## dm-mapping 0.4.1, 2008-08-14

* removed type hack, replaced with rejecting special type to lookup.

## dm-mapping 0.4.0, 2008-08-04

* added Migration#auto_genclass!.
* updated README.
* added more rdoc.

## dm-mapping 0.3.0, 2008-08-04

* added support of mapping Integer, DateTime, etc.
* renamed some internals.
* changed the way requiring adapter. no more setup first.
* added Migration#storages_and_fields
* added mapping :serial => true for primary key.
* added mapping :default, and :nullable.
* added support of mapping name. (through passing symbol or string)
* added support of multiple arguments.
* removed Mapping::All, use /.*/ instead.

## dm-mapping 0.2.1, 2008-08-03

* fixed a bug that type map should lookup for parent.
* fixed a bug that sql type could be lower case.
  fixed by calling upcase.

## dm-mapping 0.2.0, 2008-08-02

* added Sqlite3Adapter::Migration#fields
* added DataMapper::Model#mapping
* added DataMapper::Model#fields
* added DataMapper::TypeMap#find_primitive for reversed lookup.
  mapping SQL type back to Ruby type.
* added corresponded test.

## dm-mapping 0.1.0, 2008-07-27

* birthday!
* added DataMapper.repository.storages for sqlite3.
* please refer:
  <http://groups.google.com/group/datamapper/browse_thread/thread/b9ca41120c5c9389>

original message:

    from Lin Jen-Shin
    to DataMapper
    cc godfat
    date	Sun, Jul 27, 2008 at 5:40 PM
    subject Manipulate an existing database.
    mailed-by gmail.com

    Greetings,

    DataMapper looks very promising for me, so I am thinking of
    using it in the near future. I hate separate my domain objects into
    two parts in Rails, writing migration and switching to ActiveRecord,
    vice versa, is very annoying to me.

    But there's a very convenient feature to me in ActiveRecord,
    that is ActiveRecord automatically mapping all fields in a table.
    It makes me easily control an existing database without any domain object.

    For example,

      require 'active_record'

      ActiveRecord::Base.establish_connection(
        :adapter => 'sqlite3',
        :database => 'db/development.sqlite3'
      )

      clsas User < ActiveRecord::Base
      end

      User.find 1
      => #<User id: 1, account: "admin", created_at: "2008-05-18 20:08:37", etc.>

    Some people would use database admin such as phpMyAdmin to
    accomplish this kind of task, but I prefer anything in Ruby,
    calling Ruby function, manipulating data without SQL and
    any domain object. (i.e. I didn't have to load up entire environment.)

    In DataMapper, I didn't find an easy way to accomplish this.
    I am sorry if there's one but I didn't find it, please point out,
    many thanks. In short, I would like to do this in DataMapper:

      class User
        include DataMapper::Resource
        mapping :account, :created_at
      end

    or

      class User
        include DataMapper::Resource
        mapping All
      end

      class User
        include DataMapper::ResourceAll
      end

    or

      class User
        include DataMapper::Resource
        mapping *storage_fields
      end

    The above User.storage_fields should return an Array,
    telling all the fields in the table, e.g. [:account, :created_at, :etc]
    or a Hash includes data type, e.g. {:account => String,
                                        :created_at => DateTime}
    then mapping *storage_fields should change to:

      mapping *storage_fields.each_key.to_a

    If it's possible, a feature returning the database schema as well:

      DataMapper.repository.storages
      # => [:users, :posts, :etc]

      DataMapper.repository.storages_and_fields
      # => {:users => {:account => String},
            :posts => {:title => String, :content => Text}}

    or returning DataObject::Field, DataObject::Storage, etc.

      DataMapper.repository.storage
      # => [#<DataObject::Storage @name='users' @fields=
             [#<DataObject::Field @name='account' @type=String>]>]

    If you feel this kind of feature is indeed needed or not bad for
    adding it, I could try to provide a patch for it. Though I didn't
    read the source code deeply, not knowning it's easy or not.

    sincerely,
