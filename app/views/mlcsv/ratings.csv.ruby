require 'nkf'

header =%w|machine_id visitor_token rating|
csv = NKF::nkf('--sjis -Lw', header.to_csv)

@ratings.each do |k, v|
  line = [ k[1], k[0], v[:rating] ]
  csv << NKF::nkf('--sjis -Lw', line.to_csv)
end

csv
