CommonwealthPublicInterface::Application.routes.draw do
  Bpluser.add_routes(self)

  mount Bpluser::Engine => '/bpluser'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "users/registrations", :sessions => "users/sessions"}

  #mount Bpl::InstitutionManagement::Engine => '/'

  mount Hydra::RoleManagement::Engine => '/'

  root :to => 'pages#home'

  put 'bookmarks/item_actions', :to => 'folder_items_actions#folder_item_actions', :as => 'selected_bookmarks_actions'

  # not using the default below as it requires controller and path to have same name
  # blacklight_for :catalog

  # add all BL routes locally -- stopgap solution until patch can be submitted
  # that will allow local app to provide :path option for resources passed as
  # args to blacklight/lib/blacklight/rails/routes.rb#blacklight_for
  delete 'bookmarks/clear', :to => 'bookmarks#clear', :as => 'clear_bookmarks'
  resources :bookmarks
  get 'search_history', :to => 'search_history#index', :as => 'search_history'
  delete 'search_history/clear', :to => 'search_history#clear', :as => 'clear_search_history'
  delete 'saved_searches/clear', :to => 'saved_searches#clear', :as => 'clear_saved_searches'
  get 'saved_searches', :to => 'saved_searches#index', :as => 'saved_searches'
  put 'saved_searches/save/:id', :to => 'saved_searches#save', :as => 'save_search'
  delete 'saved_searches/forget/:id', :to => 'saved_searches#forget', :as => 'forget_search'
  post 'saved_searches/forget/:id', :to => 'saved_searches#forget'
  get 'search/opensearch', :to => 'catalog#opensearch', :as => 'opensearch_catalog'
  get 'search/citation', :to => 'catalog#citation', :as => 'citation_catalog'
  #get 'search/email', :as => 'email_catalog'
  #post 'search/email'
  match 'search/email', :to => 'catalog#email', :as => 'email_catalog', :via => [:get, :post]
  get 'search/facet/:id', :to => 'catalog#facet', :as => 'catalog_facet'
  get 'search', :to => 'catalog#index', :as => 'catalog_index'
  resources :solr_document, :path => 'search', :controller => 'catalog', :only => [:show, :update] do
    member do
      post 'track'
    end
  end
  # :show and :update are for backwards-compatibility with catalog_url named routes
  resources :catalog, :only => [:show, :update]
  # end local BL routes override

  get 'places', :to => 'catalog#places_facet', :as => 'places_facet'
  get 'search/:id/librarian_view', :to => 'catalog#librarian_view', :as => 'librarian_view_catalog'

  #HydraHead.add_routes(self) # deprecated in HH7

  resources :downloads, :only => [:show]

  resources :collections, :only => [:index, :show]
  get 'collections/facet/:id', :to => 'collections#facet', :as => 'collections_facet'

  resources :institutions, :only => [:index, :show]
  get 'institutions/facet/:id', :to => 'institutions#facet', :as => 'institutions_facet'

  # for some reason feedback submit won't work w/o this addition
  match 'feedback', :to => 'feedback#show', :via => [:get, :post]
  get 'feedback/complete', :to => 'feedback#complete'

  get 'folders/public', :to => 'folders#public_list', :as => 'public_folders'

  resources :folders

  resources :folder_items

  resources :preview, :only => :show

  delete 'folder/:id/clear', :to => 'folder_items#clear', :as => 'clear_folder_items'
  #match "folder/:id/remove", :to => "folder_items#delete_selected", :as => "delete_selected_folder_items"
  put 'folder/:id/item_actions', :to => 'folder_items_actions#folder_item_actions', :as => 'selected_folder_items_actions'

  #match "folder/create_folder_catalog", :to => "folders#create_folder_catalog", :as => "create_folder_catalog"

  get 'explore', :to => 'pages#explore', :as => 'explore'
  get 'about', :to => 'pages#about', :as => 'about'
  get 'about_dc', :to => 'pages#about_dc', :as => 'about_dc'
  get 'for_libraries' => redirect('http://digitalcommonwealth.memberlodge.org/')
  get 'for_educators', :to => 'pages#lesson_plans', :as => 'for_educators'
  get 'lesson_plans', :to => 'pages#lesson_plans', :as => 'lesson_plans'
  get 'copyright', :to => 'pages#copyright', :as => 'copyright'
  get 'partners', :to => 'pages#partners', :as => 'partners'
  get 'blog' => redirect('http://blog.digitalcommonwealth.org/'), :as => 'blog'

  resources :users, :only => :show

  get 'image_viewer/:id', :to => 'image_viewer#show', :as => 'image_viewer'

  get 'iiif', :to => 'iiif_request#show', :as => 'iiif_request'

  # ROUTES FOR OLD DIGITAL COMMONWEALTH PAGES
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
