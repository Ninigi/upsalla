# Upsalla

Upsalla provides a more "rubyish" way to interact with the official UPS APIS (XML-Version).
Instead of writing lengthy XML (which I personally do not think is readable and/or very intuitive way to handle data), use the provided connectors and pass in
the essential information, or write your own if the API you need is not (yet) provided in the default connectors.

**This gem is still under heavy development, so I would not recommend using it in production!** However, if you want to contribute by writing a connector, reporting a bug, help with the documentation, or just provide (constructive) feedback you are very welcome!

## Installation

Add this line to your application"s Gemfile:

```ruby
gem "upsalla"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install upsalla

## Usage

### Getting started

Require and set up Upsalla with your API credentials

``` ruby
require "upsalla"

Upsalla.api_key = "YourKey"
Upsalla.api_user = "UAEandsomestuff"
Upsalla.api_password = "YourPassword"
```

Now you can use the connectors

``` ruby
connection = Upsalla::Connection.new
```

Connection will set up all registered Connector classes and provide instance methods for them.
For example, there is a connector class called `RatingServiceSelection`, this will provide you with the `rating_service_selection(payload = {})` method.

``` ruby
payload = {
  "Shipper" => {
    "Address" => {
      "City" => "Tokyo",
      "CountryCode" => "JP"
    }
  },
  "ShipTo" => {
    "Address" => {
      "PostalCode" => "81377",
      "CountryCode" => "DE"
    }
  },
  "Service" => {
    "Code" => "65"
  },
  "Package" => {
    "PackagingType" => {
      "Code" => "00"
    },
    "PackageWeight" => {
      "UnitOfMeasurement" => {
        "Code" => "KGS"
      },
      "Weight" => "5"
    },
    "Dimensions" => {
      "Length" => "10",
      "Width" => "5",
      "Height" => "7"
    }
  }
}

request = connection.rating_service_selection payload
# => #<Upsalla::Request:0x007ff9313508b8 ...>
```

Running the connector methods will do a request to the UPS-API and return a request object. You can enter the complete response with `request.response`

``` ruby
request.response
# => {"RatingServiceSelectionResponse"=>{"Response"=>{"ResponseStatusCode"=>"1", "ResponseStatusDescription"=>"Success"}, "RatedShipment"=>{"Service"=>{"Code"=>"65"}, ...
```

or just view the "gist" by calling `request.parsed_response` which will ommit the "ResponseCode" etc. and just show the answers "body"

``` ruby
request.parsed_response
# => {"Service"=>{"Code"=>"65"}, "RatedShipmentWarning"=>"Your invoice may vary from the displayed reference rates", "BillingWeight"=>{"UnitOfMeasurement"=>{"Code"=>"KGS"}, "Weight"=>"5.0"}, ...
```

## You know it's actually "Uppsala", right?

Yes, but that would destroy the pun, so I went for "Upsalla", which is like saying "oops" in german. Since this gem is basically a fun side project for me, I figured it might be fitting more often than not.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/upsalla. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
