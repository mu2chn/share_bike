class Payment
  require 'paypal-checkout-sdk'
  include PayPalCheckoutSdk::Orders

  SUCCESS = 0
  CANNOT_EXECUTED = 1

  IS_PRODUCTION = true #Rails.env.production?

  CLIENT_ID = IS_PRODUCTION ? "AV02sWIY3UBQuPKjJVBbFSkOTIXneMPSR8y7wdgI0p_geuz6Tygaes2P6E6eqvTQtJQIAuVvBIyOqcFU"
                  : "AbmTHlJhDD2_U9v4JbjXULVdrAcAAFJqb1ZH-ZbpICzZuYWjaMwiQsOoXCytKCcqK2BfP31zjMTpC7sT"
  CLIENT_SECRET = IS_PRODUCTION ? ENV['LIVE_CLIENT_SECRET']
                  : "EOo9mHVWT1T4fubdtQErBcgEXIbd3XTEiCrKjr9l3CwNzDW59PgYlcNP7dEp1DSvYyaAYkXwPexFwZ0_"

  DEPOSIT = 300
  DUMP_PERCENT = 0.4

  def self.init_client
    begin
      environment = IS_PRODUCTION ? PayPal::LiveEnvironment.new(CLIENT_ID, CLIENT_SECRET) : PayPal::SandboxEnvironment.new(CLIENT_ID, CLIENT_SECRET)
      client = PayPal::PayPalHttpClient.new(environment)
    rescue => e
      p e.result
      raise
    end
    return client
  end

  def self.refund(capture_id, client=self.init_client)
    begin
      refund = PayPalCheckoutSdk::Payments::CapturesRefundRequest::new(capture_id)
      res = client.execute(refund)
    rescue => e
      raise CustomException::PaymentErr::new("refund failed (#{e.status_code.to_s + e.result.to_s})", e)
    end
    res
  end

  def self.capture(authorization_id, capture_body, client=self.init_client)
    begin
      request = PayPalCheckoutSdk::Payments::AuthorizationsCaptureRequest::new(authorization_id)
      request.prefer("return=representation")
      request.request_body(capture_body)
      res = client.execute(request)
    rescue => e
      raise CustomException::PaymentErr::new("capture failed", e)
    end
    res
  end

  def self.order(order_id, client=self.init_client)
    begin
      order = PayPalCheckoutSdk::Orders::OrdersGetRequest::new(order_id)
      order_detail = client.execute(order)
    rescue => e
      raise CustomException::PaymentErr::new("order failed", e)
    end
    return order_detail
  end


  def self.void(authorization_id, client=self.init_client)
    begin
      void = PayPalCheckoutSdk::Payments::AuthorizationsVoidRequest::new(authorization_id)
      void_detail = client.execute(void)
    rescue => e
      raise CustomException::PaymentErr::new("void failed", e)
    end
    void_detail
  end

  def self.re_auth(authorization_id, client=self.init_client)
    begin
      re_auth = PayPalCheckoutSdk::Payments::AuthorizationsReauthorizeRequest::new(authorization_id)
      re_auth_detail = client.execute(re_auth)
    rescue => e
      raise CustomException::PaymentErr::new("re auth failed", e)
    end
    re_auth_detail
  end

end