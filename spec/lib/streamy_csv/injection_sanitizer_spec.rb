$: << File.join(File.dirname(__FILE__), "../../../lib")
require 'streamy_csv/injection_sanitizer'
require 'csv'

describe StreamyCsv::InjectionSanitizer do
  describe 'sanitize_csv_row' do
    it "returns the data as is in case it's not a csv row" do
      StreamyCsv::InjectionSanitizer.sanitize_csv_row(10).should == 10
    end

    it 'escapes the leading escape leading | character on any column' do
      row = CSV::Row.new([:x], ["|RAND()"])
      sanitized_row = StreamyCsv::InjectionSanitizer.sanitize_csv_row(row)
      sanitized_row.to_s.strip.should == "'|RAND()"
    end

    it 'escapes the leading escape leading + character on any column' do
      row = CSV::Row.new([:x], ["-RAND()"])
      sanitized_row = StreamyCsv::InjectionSanitizer.sanitize_csv_row(row)
      sanitized_row.to_s.strip.should == "'-RAND()"
    end

    it 'escapes the leading escape leading + character on any column' do
      row = CSV::Row.new([:x], ["+RAND()"])
      sanitized_row = StreamyCsv::InjectionSanitizer.sanitize_csv_row(row)
      sanitized_row.to_s.strip.should == "'+RAND()"
    end
    it 'escapes the leading escape leading @ character on any column' do
      row = CSV::Row.new([:x], ["@RAND()"])
      sanitized_row = StreamyCsv::InjectionSanitizer.sanitize_csv_row(row)
      sanitized_row.to_s.strip.should == "'@RAND()"
    end
    it 'escapes the leading escape leading = character on any column' do
      row = CSV::Row.new([:x], ["=RAND()"])
      sanitized_row = StreamyCsv::InjectionSanitizer.sanitize_csv_row(row)
      sanitized_row.to_s.strip.should == "'=RAND()"
    end
  end
end
