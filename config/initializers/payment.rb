class Payment
  require 'paypal-checkout-sdk'
  include PayPalCheckoutSdk::Orders

  SUCCESS = 0
  CANNOT_EXECUTED = 1

  CLIENT_ID = "AbmTHlJhDD2_U9v4JbjXULVdrAcAAFJqb1ZH-ZbpICzZuYWjaMwiQsOoXCytKCcqK2BfP31zjMTpC7sT"
  CLIENT_SECRET = "EOo9mHVWT1T4fubdtQErBcgEXIbd3XTEiCrKjr9l3CwNzDW59PgYlcNP7dEp1DSvYyaAYkXwPexFwZ0_"

  def self.init_client
    begin
      environment = PayPal::SandboxEnvironment.new(CLIENT_ID, CLIENT_SECRET)
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
      p e.result
      return [1, e.status_code.to_s + e.result.to_s]
    end
    return [0, res]
  end

  def self.auth(authorization_id, client=self.init_client)
    begin
      request = PayPalCheckoutSdk::Payments::AuthorizationsCaptureRequest::new(authorization_id)
      request.prefer("return=representation")
      request.request_body({})
      res = client.execute(request)
    rescue => e
      p e.result
      return [1, e.status_code.to_s + e.result.to_s]
    end
    return [0, res]
  end

  def self.order(order_id, client=self.init_client)
    begin
      order = PayPalCheckoutSdk::Orders::OrdersGetRequest::new(order_id)
      order_detail = client.execute(order)
    rescue => e
      return [1, e.status_code.to_s + e.result.to_s]
    end
    return [0, order_detail]
  end


  def self.void(authorization_id, client=self.init_client)
    begin
      void = PayPalCheckoutSdk::Payments::AuthorizationsVoidRequest::new(authorization_id)
      void_detail = client.execute(void)
    rescue => e
      return [1, e.status_code.to_s + e.result.to_s]
    end
    return [0, void_detail]
  end

end