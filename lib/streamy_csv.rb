require "streamy_csv/version"
require "streamy_csv/injection_sanitizer"

module StreamyCsv

  # stream_csv('data.csv', MyModel.header_row) do |rows|
  #   MyModel.find_each do |my_model|
  #     rows << my_model.to_csv_row
  #   end
  # end
  #
  #

  def stream_csv(file_name, header_row, &block)
    set_streaming_headers
    set_file_headers(file_name)

    response.status = 200

    self.response_body = csv_lines(header_row, &block)
  end

  protected

  def set_streaming_headers
    headers['X-Accel-Buffering'] = 'no'
    headers["Cache-Control"] ||= "no-cache"
    headers.delete("Content-Length")
  end

  def csv_lines(header_row, &block)

    Enumerator.new do |rows|
      def rows.<<(row)
        super StreamyCsv::InjectionSanitizer.sanitize_csv_row(row).to_s
      end
      rows << header_row if header_row
      block.call(rows)
    end

  end

  def set_file_headers(file_name)
    headers["Content-Type"] = "text/csv"
    headers["Content-disposition"] = "attachment; filename=\"#{file_name}\""
  end

end

ActionController::Base.send :include, StreamyCsv
