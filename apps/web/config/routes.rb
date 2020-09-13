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

get '/learn', to: 'learn#index', as: 'learn'
get '/word_lists/:word_list_id/learn', to: 'learn#index', as: 'learn_word_list'
get '/learn/find_word', to: 'learn#find_word', as: 'learn_find_word'
