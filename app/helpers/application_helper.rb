module ApplicationHelper
  def strip_kabu str
    str.to_s.gsub(/(株式|有限|合.)会社/, '')
  end

  def lazy_image_tag source, options = {}
    options['data-original'] = source
    if options[:class].blank?
      options[:class] = "lazy"
    else
      options[:class] = options[:class].to_s + " lazy"
    end
    image_tag 'blank.png', options
  end
end
