class UsersController < ApplicationController
  include UsersHelper

  def new

  end

  def create

  end

  def show
    @current_user = current_user
  end

  def update

  end
end
