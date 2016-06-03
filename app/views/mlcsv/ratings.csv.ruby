require 'nkf'

header =%w|visitor_token machine_id rating|
csv = NKF::nkf('--sjis -Lw', header.to_csv)

@ratings.each do |k, v|
  line = [ k[0], k[1], v[:rating] ]
  csv << NKF::nkf('--sjis -Lw', line.to_csv)
end

csv
