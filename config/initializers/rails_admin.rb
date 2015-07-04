RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan
  config.authorize_with do
    authenticate_or_request_with_http_basic('ログインしてください') do |account, passwd|
      account == Rails.application.secrets.admin_account &&
      passwd  == Rails.application.secrets.admin_passwd
    end
  end

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration
  config.navigation_static_label = "リンク"
  config.navigation_static_links = {
    'e-kikai トップページ'        => 'http://www.e-kikai.com/',
    'マシンライフ トップページ'   => 'http://www.zenkiren.net/',
    'Google Analytics'            => "https://www.google.com/analytics/web/#report/visitors-overview/a629388w1051956p1037262/",
    "Google ウェブマスターツール" => "https://www.google.com/webmasters/tools/dashboard?hl=ja&pli=1&siteUrl=http%3A%2F%2Fwww.e-kikai.com%2F",
    "Clicky"                      => "https://clicky.com/user/",
    "Lucky Orange"                => "http://www.luckyorange.com/v3/dash.php?s=1&r=32743#/dashboard",
  }
  config.model 'Machines' do
    weight 500
    object_label_method :custome_name_method
    edit do
      field :company
      field :no
      field :genre
      field :name
      field :maker
      field :model
      field :capacity
      field :year
      field :location
      field :addr1
      field :addr2
      field :addr3
      field :spec
      field :accessory
      field :comission
      field :comment
      field :images
      field :machinelife_id
      field :machinelife_images
    end
  end

  def custome_name_method
    "#{self.name} #{self.maker} #{self.model}"
  end

  config.model 'LargeGenre' do
    weight 200
    edit do
      field :name
      field :order_no
      field :machinelife_id
    end
  end

  config.model 'MiddleGenre' do
    parent LargeGenre
    object_label_method :middle_genre_name_method

    edit do
      field :large_genre
      field :name
      field :order_no
      field :machinelife_id
    end
  end

  def middle_genre_name_method
    "#{self.large_genre.name} > #{self.name}"
  end

  config.model 'Genre' do
    parent MiddleGenre
    object_label_method :genre_name_method

    edit do
      field :middle_genre
      field :name
      field :capacity_label
      field :capacity_unit
      field :order_no
      field :machinelife_id
    end
  end

  def genre_name_method
    "#{self.large_genre.name} > #{self.middle_genre.name} > #{self.name}"
  end

  config.model 'Companies' do
    weight 600
    navigation_icon 'icon-home'

    edit do
      field :name
      field :company_kana
      field :representative
      field :officer
      field :tel
      field :fax
      field :mail
      field :zip
      field :addr1
      field :addr2
      field :addr3
      field :website
      field :machinelife_id
      field :machinelife_images
      field :subdomain
    end
  end

  config.model 'User' do
    weight 700
    navigation_icon 'icon-user'
    edit do
      field :email
      field :password
      field :company
      # filed :username
    end
  end

  config.model 'Contacts' do
    weight 800
    navigation_icon 'icon-envelope'
  end

  config.model 'Image' do
    weight 900
    navigation_icon 'icon-picture'
    edit do
      field :img
    end
  end

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new do
      except ["Contact"]
    end
    export
    bulk_delete
    show
    edit do
      except ["Contact"]
    end
    delete
    show_in_app do
      except ["Contact"]
    end

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
