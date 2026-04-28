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

    # Column-width styles. Reference by name, e.g. style: column_for("4cm").
    # rodf 1.2's set_column_widths is broken (serializes hash as the width
    # attribute), so we register column styles and emit explicit t.column lines.
    %w[1cm 1.5cm 2cm 2.5cm 3cm 3.5cm 4cm 4.5cm 5cm 6cm 8cm].each do |w|
      spreadsheet.style column_for(w), family: :column do |s|
        s.property :column, "column-width" => w
      end
    end

    spreadsheet
  end

  def self.column_for(width)
    "col-#{width.tr('.', '_')}"
  end
end
