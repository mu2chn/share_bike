class TouristBike < ApplicationRecord
  belongs_to :bike
  belongs_to :tourist, optional: true
  belongs_to :reward, optional: true

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

  #noinspection RubyResolve
  def freeze_reserve
    if self.status_end? || self.status_default?
      self.status_freeze!
      return "凍結完了"
    end
    "凍結できません"
  end

  def dump_reward
    return 'ダンプできなかった' if self.tourist_id.nil?
    #noinspection RubyResolve
    # set amount and currency
    transaction = Transaction.find(self.transaction_id)
    amount = transaction.ticket_amount*0.4
    currency = transaction.currency
    user_id = self.bike.user_id
    ActiveRecord::Base.transaction do
      reward = Reward.create!(
          amount: amount,
          currency: currency,
          user_id: user_id,
          tourist_bike_id: self.id
      )
      self.update_attributes!(reward_id: reward.id)
      #noinspection RubyResolve
      self.status_complete!
    end
    "ダンプしました"
  end

  #shoud not use
  #def back_reward
  #  reward = Reward.find_by(tourist_bike_id: self.id)
  #  if reward.nil? || reward.payout_id.present? || reward.already_payout
  #    nil
  #  else
  #    reward.destroy
  #    #noinspection RubyResolve
  #    self.status_freeze!
  #  end
  #end

  #########################
  # admin methods
  #########################

  def cancel
    #noinspection RubyResolve
    if self.tourist_id.nil?
      return [1, "no record"]
    elsif self.status_complete?
      return [1, "すでにrewardに追加されたため、払い戻しできません"]
    end

    trans = Transaction.find(self.transaction_id)
    status = trans.refund_before_ride(Payment.init_client)
    if status[0] == 0
      ActiveRecord::Base.transaction do
        self.update_attributes!(
            transaction_id: nil,
            tourist_id: nil,
            status: 'default'
        )
      end
    end
    status
  end

  def get_deposit
    if self.tourist_id.nil?
      return [1, "no record"]
    end

    #noinspection RubyResolve
    if self.status_end?
      trans = Transaction.find(self.transaction_id)
      status = trans.capture_for_deposit({amount: {value: 2000, currency_code: "JPY"}})
      return status
    end
    [1, "not finished rental or already completed"]
  end


  def refund_deposit
    if self.tourist_id.nil?
      return [1, "no record"]
    end

    trans = Transaction.find(self.transaction_id)
    status = trans.refund_for_deposit
  end
end

