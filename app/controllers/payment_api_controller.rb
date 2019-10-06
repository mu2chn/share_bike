class PaymentApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  require 'paypal-sdk-rest'
  include PayPal::SDK::OpenIDConnect
  include PayPal::SDK::REST

# Update client_id, client_secret and redirect_uri
  PayPal::SDK.configure({
                            :openid_client_id     => "AbmTHlJhDD2_U9v4JbjXULVdrAcAAFJqb1ZH-ZbpICzZuYWjaMwiQsOoXCytKCcqK2BfP31zjMTpC7sT",
                            :openid_client_secret => "EOo9mHVWT1T4fubdtQErBcgEXIbd3XTEiCrKjr9l3CwNzDW59PgYlcNP7dEp1DSvYyaAYkXwPexFwZ0_",
                        })

  def test
    @payment_history = Payment.all( :count => 5 )

    # List Payments
    logger.info "List Payment:"
    @payment_history.payments.each do |payment|
      logger.info "  -> Payment[#{payment.id}]"
    end
    render about_path
  end

  def check
    json = JSON.parse(request.body.read)

    # p Tokeninfo.authorize_url( :scope => "openid profile" )
    # payment_history = Payment.all( :count => 10 )
    # p payment_history.payments
    # p payment_history.count
    # p payment = Payment.find(p json["orderID"])

    @payment_history = Payment.all( :count => 5 )

    # List Payments
    logger.info "List Payment:"
    @payment_history.payments.each do |payment|
      logger.info "  -> Payment[#{payment.id}]"
    end
  end

  def unpaid

  end


end
