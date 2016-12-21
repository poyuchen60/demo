Rails.application.routes.draw do
  resources :events do
  	resources :attendees, controller: "event_attendees"
    collection do
      get :latest
      post :bulk_update
    end

    member do 
      get :dashboard
    end
  end

  namespace :admin do
    resources :events
  end
  
  resources :people
  get "welcome/say_hello" => "welcome#say"
  get "welcome" => "welcome#index"
  
  root to: "welcome#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  # match ':controller(/:action(/:id(.:format)))', :via => :all
end
