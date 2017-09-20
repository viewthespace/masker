# Masker

[![CircleCI](https://circleci.com/gh/viewthespace/masker.svg?style=svg)](https://circleci.com/gh/viewthespace/masker)

This gem allows users to mask sensitive data in Postgres databases.

# Installation

```ruby
gem install masker
```

or

```ruby
gem 'masker'
```
```ruby
bundle
```

# Usage

### Configuration

A yaml file is required to specify the tables and columns to be masked:

```
mask:
  users:
    name: :name
    email: :email
    ssn: ''
    address_id: :integer
  phones:
    imei:
    number: :phone
    non_existing_column:
  computers:
    type: 'Mac'
truncate: [addresses]
```

Tables to mask should be specified under the `mask` key. Under each table you can specify the columns that you want masked. Each column should specify how it wants to be masked. Check out the `Types` section to see different values you can specify. If no masking value is specified for the column, `NULL` will be used. You can also use your own value, like `computers#type` in the example.

Columns that are not specified in the config file will not be masked.

Tables can be truncated by specifying the `truncate` key followed by an array of table names.

### Running

`Masker.new(database_url: 'your_postgres_db_url', config_path: 'path/to/config.yml').mask`

### Options

The initializer accepts `logger` and `opts` as optional parameters. If `logger` is not specified, no logging will be outputted. You can choose table `ids` that should not be masked by specifying `opts[:safe_ids]`. For example:

```ruby
opts = {
  safe_ids: {
    users: [1, 2, 3, 4],
    phones: [1, 2, 3, 4]
  }
}


Masker.new(database_url: 'your_postgres_db_url', config_path: 'path/to/config.yml', logger: Rails.logger, opts: opts).mask

```
This will prevent masking of users and phones with id: 1, 2, 3, 4.

# Types
Masker uses [faker](https://github.com/stympy/faker) under the hood to create fake values. These are the different types you can choose from:
```
:name
:company_name
:first_name
:last_name
:email
:text
:date
:city
:domain_name
:country
:characters
:zip_code
:year
:integer
:low_integer
:float
:state
:phone
:street_address
```

# License
This code is free to use under the terms of the MIT license.
