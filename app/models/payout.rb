class Payout < ApplicationRecord

  def self.capture_from_rewards
    previous_version = Payout.where(manual_input: false).maximum(:payout_version)
    max_version = previous_version ? previous_version + 1 : 1
    last_month = Time.now.last_month
    #during = last_month.all_month
    target_rewards = Reward.joins(:tourist_bike).includes(:tourist_bike)
                         .where(payout_id: nil)
                         .where(tourist_bikes:{end_datetime: (last_month-100.years)..last_month.end_of_month})

    target_rewards.each do |reward|
      payout = Payout.where(user_id: reward.user_id, payout_version: max_version)

      if payout.present?
        found_payout = payout[0]
        prev_amount = found_payout.amount
        ActiveRecord::Base.transaction do
          found_payout.update_attributes!(
              amount: prev_amount+reward.amount
          )
          reward.update_attributes!(
              payout_id: found_payout.id,
              already_payout: true
          )
        end
      else
        new_payout = Payout.new(
            payout_version: max_version,
            paid_id: "REW0-#{reward.user_id}-#{max_version}",
            currency: reward.currency,
            user_id: reward.user_id,
            target_email: reward.user.email,
            amount: reward.amount,
            send_text: "#{last_month.strftime("%Y年%m月")}のレンタル代金を送金いたします。（トラブルが発生していた場合、先月以前のものも含まれている可能性があります。）今後ともよろしくお願いいたします。",
            detail: "#{last_month.strftime("%Y年%m月")}レンタル代金"
        )
        ActiveRecord::Base.transaction do
          new_payout.save!
          reward.update_attributes!(
              payout_id: new_payout.id,
              already_payout: true
          )
        end
      end
    end
  end

end
