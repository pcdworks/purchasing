# Shared style helpers for RODF spreadsheets.
# Call OdsStyles.apply(spreadsheet) once after creating the document, then
# reference the named styles ("header", "subheader", "currency", "total")
# from cells/rows.
module OdsStyles
  HEADER_BG     = "#222222"
  HEADER_FG     = "#ffffff"
  SUBHEADER_BG  = "#dddddd"
  TOTAL_BG      = "#f3f3f3"

  def self.apply(spreadsheet)
    spreadsheet.style "header", family: :cell do |s|
      s.property :text, "font-weight" => :bold, color: HEADER_FG
      s.property :cell, "background-color" => HEADER_BG,
                        "border" => "0.5pt solid #000000"
    end

    spreadsheet.style "subheader", family: :cell do |s|
      s.property :text, "font-weight" => :bold
      s.property :cell, "background-color" => SUBHEADER_BG,
                        "border" => "0.5pt solid #000000"
    end

    spreadsheet.style "currency", family: :cell do |s|
      s.property :cell, "border" => "0.25pt solid #999999"
    end

    spreadsheet.style "total", family: :cell do |s|
      s.property :text, "font-weight" => :bold
      s.property :cell, "background-color" => TOTAL_BG,
                        "border" => "0.5pt solid #000000"
    end

    spreadsheet.style "cell", family: :cell do |s|
      s.property :cell, "border" => "0.25pt solid #999999"
    end

    spreadsheet
  end
end
