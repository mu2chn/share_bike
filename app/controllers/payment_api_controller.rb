class PaymentApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  # require 'paypal-sdk-rest'
  # include PayPal::SDK::OpenIDConnect
  # include PayPal::SDK::REST

  require 'paypal-checkout-sdk'
  include PayPalCheckoutSdk::Orders


# Update client_id, client_secret and redirect_uri
#   PayPal::SDK.configure({
#                             :openid_client_id     => "AbmTHlJhDD2_U9v4JbjXULVdrAcAAFJqb1ZH-ZbpICzZuYWjaMwiQsOoXCytKCcqK2BfP31zjMTpC7sT",
#                             :openid_client_secret => "EOo9mHVWT1T4fubdtQErBcgEXIbd3XTEiCrKjr9l3CwNzDW59PgYlcNP7dEp1DSvYyaAYkXwPexFwZ0_",
#                         })

  def test
    # @payment_history = Payment.all( :count => 5 )
    #
    # # List Payments
    # logger.info "List Payment:"
    # @payment_history.payments.each do |payment|
    #   logger.info "  -> Payment[#{payment.id}]"
    # end
    render about_path
  end

  def check
    client_id = "AbmTHlJhDD2_U9v4JbjXULVdrAcAAFJqb1ZH-ZbpICzZuYWjaMwiQsOoXCytKCcqK2BfP31zjMTpC7sT"
    client_secret = "EOo9mHVWT1T4fubdtQErBcgEXIbd3XTEiCrKjr9l3CwNzDW59PgYlcNP7dEp1DSvYyaAYkXwPexFwZ0_"
    environment = PayPal::SandboxEnvironment.new(client_id, client_secret)
    client = PayPal::PayPalHttpClient.new(environment)
    json = JSON.parse(request.body.read)
    order = PayPalCheckoutSdk::Orders::OrdersGetRequest::new(json["orderID"])
    client.execute(order)


  end

  def unpaid

  end


end
