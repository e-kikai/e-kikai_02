Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: "main#index"

  devise_for :users

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
  get  "large_genre/:id", to: "main#large_genre", as: "large_genre"
  get  "search/(/l_:large_genre_id_eq)(/m_:middle_genre_id_eq)(/g_:genre_id_eq)(/c_:company_id_eq)", to: "main#search", as: "search"
  get  "machine/:id", to: "main#machine", as: "machine"
  get  "contact/:id", to: "main#contact", as: "contact"
  post "contact",     to: "main#contact_create"
  get  "contact_fin", to: "main#contact_fin"

  resources :companies, :only => [:index, :show]

namespace :member do
  root to: "main#index"
  # get "machines", to: "main#machines"
  get   "contacts", to: "main#contacts"
  get   "company",  to: "main#company_edit"
  patch "company",  to: "main#company_update"

  resources :machines, :except => [:show]
end
end
