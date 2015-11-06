Rails.application.routes.draw do
  devise_for :company_users

  # 管理者画面(同期) rails_adminより優先
  get "admin/crawl/:target", to: "admin#crawl", as: "admin_crawl"

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  require 'sidekiq/web'
  mount Sidekiq::Web, at: "/sidekiq"

  mount Split::Dashboard, :at => '/split'

  root to: "main#index"

  # devise_for :users

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

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
  get  ":subdomain",             to: "companies#show"
  # get  ":subdomain/search"  ,    to: "companies#search" ,       as: "member_site_machines"
  get  ":subdomain/contact",     to: "companies#contact",       as: "member_site_contact"
  post ":subdomain/contact",     to: "companies#contact_create"
  get  ":subdomain/contact_fin", to: "companies#contact_fin",   as: "member_site_contact_fin"
  get  ":subdomain/detail",      to: "companies#detail"
  get  ":subdomain/map",         to: "companies#map"

end
