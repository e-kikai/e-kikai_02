class Companysite < ActiveRecord::Base
  belongs_to :company

  # store :company_configs, accessors: [:theme_color, :headcopy, :top_img_title, :top_img_content, :top_summary_title, :top_summary_content, :company_title, :company_content, :makers, :histories, :site_top_img_uid]

end
