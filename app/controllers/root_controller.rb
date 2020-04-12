class RootController < ApplicationController
  def index
    # render :layout => nil
  end

  def about
  end

  def first_t
  end

  def first_u
  end

  def place
    @parking = Parking.all
  end

end
