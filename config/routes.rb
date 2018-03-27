Rails.application.routes.draw do

  match 'api_proxy/*path' => 'api_proxy#forward',
        via: [:get, :post, :put, :patch, :delete],
        :constraints => { :path => /.*/ }

end
