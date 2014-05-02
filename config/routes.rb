resources :rates

match 'rate_caches', :to => 'rate_caches#index', :via => "get"
match 'rate_caches', :to => 'rate_caches#update', :via => "put"
