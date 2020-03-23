class PaymentApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  include PaymentsService



  def check
    success = pay_execute(JSON.parse(request.body.read))
    render json: success
  end

  def unpaid

  end


end
