module ApplicationHelper
  # include Chanko::Invoker
  # include Chanko::Helper

  def lazy_image_tag source, options = {}
    options['data-original'] = source
    if options[:class].blank?
      options[:class] = "lazy"
    else
      options[:class] = options[:class].to_s + " lazy"
    end
    image_tag 'blank.png', options
  end

  ### JSON-LD 生成 ###
  def jsonld_script_tag
    jsonld = controller.render_to_string(formats: :jsonld)
    content_tag :script, jsonld.html_safe, type: Mime[:jsonld].to_s
  rescue ActionView::ActionViewError => e
    logger.error e.message
    nil
  ensure
     # render_to_string のバグ回避 https://github.com/rails/rails/issues/14173
    lookup_context.rendered_format = nil
  end

end
