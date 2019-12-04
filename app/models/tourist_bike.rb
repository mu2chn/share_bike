class TouristBike < ApplicationRecord
  belongs_to :bike
  belongs_to :tourist, optional: true

  enum status: {
      default: 0, #自転車を借りる前、default値
      end: 30, #自転車レンタル終了、、endとunusedに分岐する
      complete: 60, #reward追加時
      unused: 80, #自転車のレンタルがなされなかったとき、endとunusedに分岐する
      freeze: 100 #凍結状態、statusの値は更新されない、手動によりのみなりうる
  }, _prefix: true

  #frozenreserveのとき、更新をしない
  def frozen_reserve?
    user_prob || tourist_prob
  end

  def dump_reward
    return nil if self.tourist_id.nil?
    #noinspection RubyResolve
    #return nil unless self.status_end?
    # set amount and currency
    transaction = Transaction.find(self.transaction_id)
    amount = transaction.ticket_amount*0.4
    currency = transaction.currency
    user_id = self.bike.user_id
    reward = Reward.create!(
        amount: amount,
        currency: currency,
        user_id: user_id,
        tourist_bike_id: self.id
    )
  end

  #shoud not use
  def back_reward
    reward = Reward.find_by(tourist_bike_id: self.id)
    if reward.nil? || reward.payout_id.present? || reward.already_payout
      nil
    else
      reward.destroy
      #noinspection RubyResolve
      self.status_freeze!
    end
  end


  #########################
  # admin methods
  #########################

  def cancel
    if self.tourist_id.nil?
      return [1, "no record"]
    elsif self.status >= 20
      return [1, "already rental started"]
    end

    trans = Transaction.find(self.transaction_id)
    status = trans.refund_before_ride(Payment.init_client)
    if status[0] == 0
      self.update_attributes(
          transaction_id: nil,
          tourist_id: nil
      )
    end
    status
  end

  def get_deposit
    if self.tourist_id.nil?
      return [1, "no record"]
    end

    if self.status <= 30 #ApplicationJob.END_RENTAL
      trans = Transaction.find(self.transaction_id)
      status = trans.capture_for_deposit({amount: {value: 2000, currency_code: "JPY"}})
      return status
    end
    [1, "not finished rental"]
  end


  def refund_deposit
    if self.tourist_id.nil?
      return [1, "no record"]
    end

    trans = Transaction.find(self.transaction_id)
    status = trans.refund_for_deposit
  end
end

