class PaymentApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  def check
    json = JSON.parse(request.body.read)
    p json
  end

  def unpaid

  end
end
