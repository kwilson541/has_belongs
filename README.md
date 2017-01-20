has_belongs
===========
[![Build Status](https://travis-ci.org/kwilson541/has_belongs.svg?branch=master)](https://travis-ci.org/kwilson541/has_belongs)
[![Coverage Status](https://coveralls.io/repos/github/kwilson541/has_belongs/badge.svg?branch=master)](https://coveralls.io/github/kwilson541/has_belongs?branch=master)

Rails Association Automation!
# has_belongs

A gem specifically for Rails projects that use PostgreSQL.

*"has_belongs"* is a gem created by four Makers Academy students from the November 2016 cohort. Makers Academy is a twelve week coding bootcamp, where we mostly learn Ruby. In week 9 of our course, we were tasked with working in small groups to create projects; and this gem is the result of that.

The idea stemmed from the prior week, where we were introduced to Ruby On Rails for the first time. We found it slightly frustrating running terminal commands to generate associations between models and decided that a gem to automate this process would be appreciated by the community.

The gem works by searching your model files to look for associations you have added. This includes one-to-one, one-to-many, and many-to-many. Once the gem has found these associations, it will create your migration files, update your database, and update your schema. If you remove your associations later, you can also ask the gem to "unmigrate". This will search your models for deleted associations, create a remove migration file, update your database, and update your schema.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'has_belongs'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install has_belongs

## Usage

Once the gem is included in your project, you can then use it to generate or remove associations once you have added the relationships in your models. When adding associations, run:

    $ has_belongs migrate

When removing associations, run:

    $ has_belongs unmigrate

With both commands, the gem will create relevant migration files in your `db/migrate` directory, including `schema.db`; and your database tables will be updated automatically. The schema will also be updated, so you can check this to ensure your database is as expected.

## Known Issues

- As highlighted above, this gem is specifically for use with Rails and PostgreSQL. As far as we are aware, it will not run as expected if other databases are used.
- All models must be created through the command line so that your database will have the basic model tables prior to adding any associations. If you do not have your model tables in place before adding associations, the migrations will fail.
- Due to the way Rails works, it is not currently possible to create, remove, and then re-create the same association. Rails will identify your first "Add Migration" and will not create a second one. If you have removed an association and wish to re-add it, you may need to delete the first "Add Migration" file before your next migrate.
- Also as far as we understand Rails and the interaction of our gem, it seems we can create join tables (through has_and_belongs_to_many associations) but they cannot be removed as Rails does not offer a simple command to accomplish this.


## Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

Bug reports and pull requests are welcome on GitHub at https://github.com/kwilson541/has_belongs. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
