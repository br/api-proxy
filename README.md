# ApiProxy

Proxy for API requests for ability to record/reply http calls via testing tool like vcr

in Gemfile:

```ruby
gem 'api-proxy', 
    git: 'https://github.com/br/api-proxy.git'
    #path: '../api-proxy'
```

Configure:

```ruby
ApiProxy.forwarding_origin = 'http://gatekeeper.1bleacherreport.com'
```

With this configuration, all requests to `/api_proxy` will be forwarded to `http://gatekeeper.1bleacherreport.com`
