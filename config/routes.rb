Rails.application.routes.draw do
  # devise_for :company_users

  constraints  subdomain: "www" do
    # 管理者画面(同期) rails_adminより優先
    # get "admin/crawl/:target", to: "admin#crawl", as: "admin_crawl"
    #
    # mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

    # require 'sidekiq/web'
    # mount Sidekiq::Web, at: "/sidekiq"

    # mount Split::Dashboard, :at => '/split'

    root to: "main#index"

    # devise_for :users

    get "mlcsv/machines", to: "mlcsv#machines"
    get "mlcsv/visitors", to: "mlcsv#visitors"
    get "mlcsv/ratings",  to: "mlcsv#ratings"

    # 機械検索
    get  "large_genre/:id", to: "main#large_genre",   as: "large_genre"
    get  "search",          to: "main#search",        as: "search"
    get  "machine/:id",     to: "main#machine",       as: "machine"
    get  "detail/:id",      to: "main#detail",       as: "detail"
    get  "contact/:id",     to: "main#contact",       as: "contact"
    post "contact",         to: "main#contact_create"
    get  "contact_fin",     to: "main#contact_fin",   as: "contact_fin"
    get  "about",           to: "main#about",         as: "about"
    get  "sitemap",         to: "main#sitemap",       as: "sitemap"

    get  "ads",             to: "main#ads",           as: "ads"

    namespace :member do
      root to: "main#index"
      # get "machines", to: "main#machines"
      get   "contacts", to: "main#contacts"
      # get   "company",  to: "main#company_edit"
      # patch "company",  to: "main#company_update"
      get   "site",  to: "main#site_edit"
      patch "site",  to: "main#site_update"
      resources :machines, :except => [:show]
    end

    # 会社情報
    resources :companies, :only => [:index]
    get  ":sd",             to: "companies#show"
    # get  ":sd/search"  ,    to: "companies#search" ,       as: "member_site_machines"
    get  ":sd/contact",     to: "companies#contact",       as: "member_site_contact"
    post ":sd/contact",     to: "companies#contact_create"
    get  ":sd/contact_fin", to: "companies#contact_fin",   as: "member_site_contact_fin"
    get  ":sd/detail",      to: "companies#detail"
    get  ":sd/map",         to: "companies#map"
  end

  constraints lambda { |request| request.subdomain != "www" } do
    get  "",             to: "companies#show"
    get  "contact",     to: "companies#contact"
    post "contact",     to: "companies#contact_create"
    get  "contact_fin", to: "companies#contact_fin"
    get  "detail",      to: "companies#detail"
    get  "map",         to: "companies#map"
  end

end
