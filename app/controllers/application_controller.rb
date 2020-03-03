class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper
  include ApplicationHelper

  def check_valid_end(res)
    end_time = res.end_datetime
    now = Time.now

    #noinspection RubyResolve
    unless res.status_start?
      return [1, "不正なステータス"]
    end
    if end_time < now
      DbLogger.dump("res:#{res.id} 返却遅延 time=#{now}")
      return [0, "返却を完了しましたが、返却時間を過ぎています。"]
    end

    [0, "返却を完了しました。"]
  end

  def check_valid_start(res)
    start_time = res.start_datetime
    end_time = res.end_datetime
    now = Time.now
    #noinspection RubyResolve
    if not res.status_default?
      return [1, "すでに貸出を開始しています。"]
    elsif end_time - 10.minutes < now
      DbLogger.dump("res:#{res.id} レンタル返却時刻10分前経過のため、貸出できてない。")
      return [1, "終了10分前を過ぎました。貸出ができません。"]
    elsif start_time > now
      return [1, "レンタル開始時刻を過ぎてからでお願いします。"]
    end
    [0, "pass"]
  end

  def during_rental(res)
    #noinspection RubyResolve
    not_end =res.status_start?
    (not_end)
  end
end
