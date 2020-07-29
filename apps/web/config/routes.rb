# Configure your routes here
# See: https://guides.hanamirb.org/routing/overview
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
root to: 'home#index'
resources :word_lists, only: [:new, :create, :show, :edit, :update]
get '/word_lists', to: 'word_lists#index'
