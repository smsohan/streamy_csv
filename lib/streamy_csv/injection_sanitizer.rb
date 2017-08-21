module StreamyCsv
  class InjectionSanitizer
    PREFIXES_TO_ESCAPE=%w(= @ + - |)
    ESCAPE_CHAR="'"

    def self.sanitize_csv_row(row)
      if row.is_a?(CSV::Row)
        sanitized_row = row.dup
        row.each do |title, value|
          if value.start_with?(*PREFIXES_TO_ESCAPE)
            sanitized_row[title] = "#{ESCAPE_CHAR}#{value}"
          end
        end
      end
      row
    end
  end
end
