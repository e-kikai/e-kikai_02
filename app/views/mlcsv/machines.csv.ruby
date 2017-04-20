require 'nkf'

header =%w|machine_id 機械名 メーカー 型式 年式|
csv = NKF::nkf('--sjis -Lw', (header.to_csv)

@machines.find_each do |m|
  line = [d[:id]] + @show_columns.map { |co| d[co.column_name] } + [d[:created_at], d[:updated_at]]
  csv << NKF::nkf('--sjis -Lw', line.to_csv)
end

csv
