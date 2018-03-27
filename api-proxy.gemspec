Gem::Specification.new do |s|
  s.name    = 'api-proxy'
  s.version = '0.0.1'
  s.date    = '2017-04-04'
  s.author  = 'Geoff Buesing'
  s.email   = 'gbuesing@gmail.com'
  s.summary = 'Proxy for API requests for ability to record/reply http calls via testing tool like vcr'
  s.license = 'MIT'
  s.homepage = 'https://github.com/br/api-proxy'

  s.add_runtime_dependency 'rest-client', '~> 2.0', '>= 2.0.1'

end