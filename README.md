has_belongs
===========
[![Build Status](https://travis-ci.org/kwilson541/has_belongs.svg?branch=master)](https://travis-ci.org/kwilson541/has_belongs)
[![Coverage Status](https://coveralls.io/repos/github/kwilson541/has_belongs/badge.svg?branch=master)](https://coveralls.io/github/kwilson541/has_belongs?branch=master)

Rails Association Automation!
# has_belongs

A gem specifically for Rails projects that use PostgreSQL.

*"has_belongs"* is a gem created by four Makers Academy students from the November 2016 cohort. Makers Academy is a twelve week coding bootcamp, where we mostly learn Ruby. In week 9 of our course, we were tasked with working in small groups to create projects; and this gem is the result of that.

The idea stemmed from the prior week, where we were introduced to Ruby On Rails for the first time. We found it slightly frustrating running terminal commands to generate associations between models and decided that a gem to automate this process would be appreciated by the community.

The gem essentially allows you to no longer type e.g. `rails g migration Add<Model1>To<Model2> <model1>:references` or `rails g migration Remove<Model1>From<Model2> <model1>:references`.

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

Once the gem is included in your project, you can then use it to generate the migrations once you have added associations in your models. When adding associations, run:

    $ has_belongs migrate
When removing associations, run:

    $ has_belongs unmigrate

With both commands, the gem you will create relevant migration files in `db/migrate` including the `schema.db` file; and your database tables will be migrated automatically as the gem runs `db:migrate`.

## Known Issues

- As highlighted above, this gem is specifically for use with Rails and PostgreSQL. As far as we are aware, it will not run as expected if other databases are used.
- All models must be created through the command line prior to setting your associations and prior to running `has_belongs migrate` or `has_belongs unmigrate`.
- Due to the way Rails works, it is not currently possible to create an association, run `has_belongs migrate`, then remove that association and run `has_belongs unmigrate` and then create the exact same association.


## Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

Bug reports and pull requests are welcome on GitHub at https://github.com/kwilson541/has_belongs. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
