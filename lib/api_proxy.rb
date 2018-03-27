require 'rest_client'

module ApiProxy

  extend self

  def forward_to(request)
    raise 'forwarding_origin not set' unless @forwarding_origin
    path = request.original_fullpath
             .gsub(/^\/api_proxy/, '')
             .gsub(/_=\d+/, '') # clean-up random-seed parameter
    method = request.request_method.downcase
    payload = request.body.is_a?(Puma::NullIO) ? nil : request.body

    hash = {
      method: method,
      url: "#{@forwarding_origin}#{path}",
      headers: {
        Authorization: request.headers['Authorization'],
        'Content-Type': 'application/json'
      },
      payload: payload,
      timeout: 60
    }

    @requests ||= []
    @requests << hash

    RestClient::Request.execute hash

  rescue StandardError => e
    if e.respond_to? :response
      error = "#{e}: #{e.response&.body}"
    else
      error = e
    end

    ApiProxy.errors << error
    puts 'ERROR in ApiProxy:'
    puts error
    raise e
  end

  def forwarding_origin=(forwarding_origin)
    @forwarding_origin = forwarding_origin
  end

  def clean
    @requests = []
    @errors = []
  end

  def errors
    @errors ||= []
  end

  def check_errors
    if errors.size > 0
      raise "Errors from ApiProxy:\n #{errors.join("\n")}"
    end
  end

  def should_have_last_request_with(expected)
    ApiProxy.check_errors

    req = @requests&.last
    raise('ApiProxy expected to have requests but there is no any') unless req

    req_info = "for request #{req[:method].upcase} #{req[:url]}"

    if expected[:method]
      unless req[:method].to_sym == expected[:method]
        raise "Expected `#{req[:method]}` to be `#{expected[:method]}` #{req_info}"
      end
    end
    if expected[:url]
      unless req[:url].match expected[:url]
        raise "Expected `#{req[:url]}` to match `#{expected[:url]}` #{req_info}"
      end
    end
  end

end