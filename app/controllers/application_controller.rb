class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper
  include ApplicationHelper


  def during_rental(res)
    #noinspection RubyResolve
    not_end =res.status_start?
    (not_end)
  end

  # refactored
  rescue_from CustomException::NamedException, with: :render_err
  def render_err(e = nil)
    path = Rails.application.routes.recognize_path(request.referer)
    flash[:warning] = e.reason
    redirect_to path
  end

  rescue_from CustomException::ExpectedException, with: :render_success
  def render_success(e = nil)
    path = e.redirect
    flash[:info] = e.msg
    redirect_to path
  end

  rescue_from CustomException::ApiNamedException, with: :render_json_err
  def render_json_err(e = nil)
    render json: {msg: e.reason}, status: :bad_request
  end

  rescue_from CustomException::ApiCustomJsonException, with: :render_custom_json_err
  def render_custom_json_err(e = nil)
    render json: e.json, status: :bad_request
  end
end
