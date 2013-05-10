# StreamyCsv

Streams CSV files one row at a time as live data is generated instead of waiting for the whole file to be created and then sent to the client. Works on most standard web servers including Nginx, Passenger, Unicorn, Thin etc., but does NOT work on Webrick.

## Installation

Add this line to your application's Gemfile:

    gem 'streamy_csv'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install streamy_csv

## Usage
In your model:

    class MyModel

      def self.header_row
        CSV::Row([:name, :title], ['Name', 'Title'], true)
      end

      def to_csv_row
        CSV::Row([:name, :title], ['John', 'Mr'])
      end

    end


In your controller:

    Class ExportsController

      def index

        stream_csv('data.csv', MyModel.header_row) do |rows|
          MyModel.find_each do |my_model|
            rows << my_model.to_csv_row
          end
        end

      end
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
