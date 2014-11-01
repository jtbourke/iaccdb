Iac::Application.routes.draw do

  ### Admin Namespace
  namespace :admin do
    root :to => "contests#index"
    resources :contests, :except => [:new, :create] do
      resources :c_results, :only => [:index, :show]
    end
    resources :contests do
      member do 
        get 'recompute'
      end
    end
    resources :manny_synchs, :only => [:index, :destroy]
    resources :members, :only => [:index, :edit, :update, :show]
    resources :failures, :only => [:index, :show, :destroy]
    resources :data_posts, :only => [:index, :show]
    resources :queues, :only => [:index, :show]
    post "members/merge_preview"
    post "members/merge"
    get 'manny_list', 
      :controller => :contests, 
      :action => "manny_list"
    get 'manny_synchs/:manny_number/retrieve', 
      :controller => :manny_synchs, 
      :action => "retrieve", 
      :as => 'manny_retrieve'
    get 'manny_synchs/:manny_number/show', 
      :controller => :manny_synchs, 
      :action => "show", 
      :as => 'manny_show'
    post 'jasper', 
      :controller => 'jasper', 
      :action => 'results'
    get 'data_post/:id/download', 
      :controller => :data_posts, 
      :action => 'download',
      :as => 'data_post_download'
    get 'data_post/:id/resubmit', 
      :controller => :data_posts, 
      :action => 'resubmit',
      :as => 'data_post_resubmit'
  end

  ### Leaders namespace
  namespace :leaders do
    root :to => "contests#index"
    get 'judges/:year', :action => :judges
    get 'judges', :action => :judges
    get 'regionals/:year', :action => :regionals
    get 'regionals', :action => :regionals
  end

  ### Default namespace
  root :to => "contests#index"

  get "pages/:title" => 'pages#page_view', :as => 'pages'

  resources :contests, :only => [:index, :show]

  resources :pilots, :only => [:index, :show] do
    resources :scores, :only => [:show]
  end

  resources :judges, :only => [:index, :show]

  resources :assistants, :only => [:index, :show]

  get 'judge/:id/cv', 
    :controller => :judges, 
    :action => :cv, 
    :as => 'judge_cv'

  resources :flights, :only => [:show]

  get 'judge/:judge_id/flight/:flight_id',
    :controller => :judges,
    :action => :histograms,
    :as => 'judge_histograms'

  namespace :further do
    get 'participation', :action => :participation
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # See how all routes lay out with "rake routes"

end
