class ApiProxyController < ApplicationController

  skip_before_action :verify_authenticity_token

  def forward
    result = ApiProxy.forward_to request
    render json: result, status: result.code
  end

end