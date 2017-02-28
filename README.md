# MaterialServiceClient

A gem for communicating with the [Materials Service](https://github.com/sanger/aker-materials).

An environment variable named MATERIALS_URL must be set with the location of the Materials Service URL.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'material_service_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install material_service_client

## Usage

All methods return the parsed response from the service (except `delete` as responses are empty).

```ruby
require 'material_service_client'

# Material
MaterialServiceClient::Material.get(uuid)
MaterialServiceClient::Material.post(material_data)
MaterialServiceClient::Material.put(material_data)
MaterialServiceClient::Material.delete(uuid)
MaterialServiceClient::Material.valid?(uuids)

# Container
MaterialServiceClient::Container.get(uuid)
MaterialServiceClient::Container.post(container_data)
MaterialServiceClient::Container.put(container_data)
MaterialServiceClient::Container.delete(uuid)
MaterialServiceClient::Container.with_criteria({:barcode => 'MY-BARCODE'})
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/material_service_client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

