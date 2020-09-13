# Configure your routes here
# See: https://guides.hanamirb.org/routing/overview
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
root to: 'home#index'
resources :word_lists, only: [:index, :new, :create, :show, :edit, :update]
resources :word_tests, only: [:create]
resources :users, only: [:new, :create]
post '/login', to: 'sessions#create', as: 'login'
delete '/sessions', to: 'sessions#destroy', as: 'logout'
get '/login', to: 'sessions#new', as: 'login'
get '/words/for_test', to: 'words#for_test'
get '/memorize', to: 'memorize#index'
get '/word_lists/:word_list_id/memorize', to: 'memorize#index'
get '/memorize/find_word', to: 'memorize#find_word', as: 'memorize_find_word'
