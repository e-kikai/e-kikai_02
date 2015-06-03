module ApplicationHelper
  def strip_kabu str
    str.to_s.gsub(/(株式|有限|合.)会社/, '')
  end
end
