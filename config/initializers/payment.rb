class Payment
  require 'paypal-checkout-sdk'
  include PayPalCheckoutSdk::Orders

  SUCCESS = 0
  CANNOT_EXECUTED = 1

  CLIENT_ID = "AbmTHlJhDD2_U9v4JbjXULVdrAcAAFJqb1ZH-ZbpICzZuYWjaMwiQsOoXCytKCcqK2BfP31zjMTpC7sT"
  CLIENT_SECRET = "EOo9mHVWT1T4fubdtQErBcgEXIbd3XTEiCrKjr9l3CwNzDW59PgYlcNP7dEp1DSvYyaAYkXwPexFwZ0_"

  def self.refund(capture_id)
    begin
      environment = PayPal::SandboxEnvironment.new(CLIENT_ID, CLIENT_SECRET)
      client = PayPal::PayPalHttpClient.new(environment)
      refund = PayPalCheckoutSdk::Payments::CapturesRefundRequest::new(capture_id)
      res = client.execute(refund)
    rescue => e
      p e.result
      return [1, e.status_code.to_s + e.result.to_s]
    end
    return [0, res.result]
  end

end