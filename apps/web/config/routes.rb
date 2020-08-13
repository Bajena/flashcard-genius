# Configure your routes here
# See: https://guides.hanamirb.org/routing/overview
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
root to: 'word_lists#index'
resources :word_lists, only: [:index, :new, :create, :show, :edit, :update]
resources :users, only: [:new, :create]
