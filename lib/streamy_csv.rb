require "streamy_csv/version"

module StreamyCsv
  CSV_OPERATORS = ['+','-','=','@','%']
  UNESCAPED_PIPES_RGX = /(?<!\\)(?:\\{2})*\K\|/

  # stream_csv('data.csv', MyModel.header_row) do |rows|
  #   MyModel.find_each do |my_model|
  #     rows << my_model.to_csv_row
  #   end
  # end
  #
  #

  def stream_csv(file_name, header_row, sanitize = true, &block)
    set_streaming_headers
    set_file_headers(file_name)

    response.status = 200

    self.response_body = csv_lines(header_row, sanitize, &block)
  end

  protected

  def set_streaming_headers
    headers['X-Accel-Buffering'] = 'no'
    headers["Cache-Control"] ||= "no-cache"
    headers.delete("Content-Length")
  end

  def csv_lines(header_row, sanitize, &block)
    Enumerator.new do |yielder|
      rows = appendHeader([], header_row, sanitize)
      block.call(rows)
      rows.each do |row|
        sanitize!(row) if sanitize
        yielder.yield row
      end
    end
  end

  def appendHeader(rows, header_row, sanitize)
    if header_row && header_row.any?
      sanitize! header_row if sanitize
      rows << header_row.to_s
    end
    rows
  end

  def sanitize!(enumerable)
    return unless enumerable && enumerable.is_a?(Enumerable)
    enumerable = enumerable.fields if enumerable.is_a?(CSV::Row)
    enumerable.each do |field|
      field.gsub!(UNESCAPED_PIPES_RGX,'\|') if field.is_a?(String) && field.start_with?(*CSV_OPERATORS)        
    end
  end

  def set_file_headers(file_name)
    headers["Content-Type"] = "text/csv"
    headers["Content-disposition"] = "attachment; filename=\"#{file_name}\""
  end

end

ActionController::Base.send :include, StreamyCsv
