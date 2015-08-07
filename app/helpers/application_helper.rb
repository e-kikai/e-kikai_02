module ApplicationHelper
  include Chanko::Invoker
  include Chanko::Helper

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
