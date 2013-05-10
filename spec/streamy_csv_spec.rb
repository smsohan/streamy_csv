require 'ostruct'

module ActionController
  class Base
    attr_accessor :response_body

    def headers
      @headers ||= {}
    end

    def response
      @response ||= OpenStruct.new
    end

  end
end

$: << File.join(File.dirname(__FILE__), "/../lib")
require 'streamy_csv.rb'
require 'csv'

describe StreamyCsv do

  it 'extends the action controller with the module' do
    ActionController::Base.ancestors.should include(StreamyCsv)
  end

  context '#stream_csv' do
    before(:each) do
      @controller = ActionController::Base.new
      @header = CSV::Row.new([:name, :title], ['Name', 'Title'], true)
    end

    it 'sets the streaming headers' do
      @controller.stream_csv('abc.csv', @header)
      @controller.headers.should include({'X-Accel-Buffering' => 'no',
        "Cache-Control" => "no-cache"
      })
    end

    it 'sets the file headers' do
      @controller.stream_csv('abc.csv', @header)
      @controller.headers.should include({"Content-Type" => "text/csv",
        "Content-disposition" => "attachment; filename=\"abc.csv\""
      })
    end

    it 'streams the csv file' do
      row_1 = CSV::Row.new([:name, :title], ['AB', 'Mr'])
      row_2 = CSV::Row.new([:name, :title], ['CD', 'Pres'])

      rows = [@header, row_1]

      @controller.stream_csv('abc.csv', @header) do |rows|
        rows << row_1
        rows << row_2
      end

      @controller.response.status.should == 200
      @controller.response_body.is_a?(Enumerator).should == true
    end
  end

end