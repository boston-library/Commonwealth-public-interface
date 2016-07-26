CommonwealthPublicInterface::Application.routes.draw do

  root :to => 'pages#home'

  # routes for CommonwealthVlrEngine
  mount CommonwealthVlrEngine::Engine => '/'

  # user authentication
  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks", :registrations => "users/registrations", :sessions => "users/sessions"}

  # bookmarks item actions
  put 'bookmarks/item_actions', :to => 'folder_items_actions#folder_item_actions', :as => 'selected_bookmarks_actions'

  concern :range_searchable, BlacklightRangeLimit::Routes::RangeSearchable.new

  mount Blacklight::Engine => '/'

  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], path: '/search', controller: 'catalog' do
    concerns :searchable
    concerns :range_searchable
  end

  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/search', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  get 'about_dc', :to => 'pages#about_dc', :as => 'about_dc'
  get 'for_libraries' => redirect('http://digitalcommonwealth.memberlodge.org/')
  get 'for_educators', :to => 'pages#lesson_plans', :as => 'for_educators'
  get 'lesson_plans', :to => 'pages#lesson_plans', :as => 'lesson_plans'
  get 'copyright', :to => 'pages#copyright', :as => 'copyright'
  get 'partners', :to => 'pages#partners', :as => 'partners'
  get 'blog' => redirect('http://blog.digitalcommonwealth.org/'), :as => 'blog'

  # ROUTES FOR OLD DIGITAL COMMONWEALTH PAGES
  get 'collections/show/:id', :to => 'pages#collection_tree'
  get 'collection-tree', :to => 'pages#collection_tree'
  get 'resources' => redirect('http://digitalcommonwealth.memberlodge.org/')
  get 'contact', :to => 'pages#contact'
  get 'gettingstarted' => redirect('http://blog.bpl.org/dcbpl/')
  get 'faqs' => redirect('http://digitalcommonwealth.memberlodge.org/FAQ')
  get 'memberfees' => redirect('http://digitalcommonwealth.memberlodge.org/membership')
  get 'lstagrant' => redirect('http://blog.bpl.org/dcbpl/')
  get 'board' => redirect('http://digitalcommonwealth.memberlodge.org/directors')
  get 'conference_presentations_2013' => redirect('http://digitalcommonwealth.memberlodge.org/2013Presentations')
  get 'annualconference' => redirect('http://digitalcommonwealth.memberlodge.org/conferences')
  get 'members' => redirect('http://digitalcommonwealth.memberlodge.org/directory')
  get 'why_join' => redirect('http://digitalcommonwealth.memberlodge.org/why_join')
  get 'items/*all', :to => 'pages#items'

  # Routes for the API
  post '/api/digital_stacks/user_create', :to => 'api#digital_stacks_create', :as => 'digital_stacks_create'
  get '/api/digital_stacks/saved_items/:id', :to => 'api#digital_stacks_login', :as => 'digital_stacks_login'

  # match 'preview/:id', :to => "preview#show"  ## TODO: figure out why this doesn't work!

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
