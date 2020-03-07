class PostsController < ApplicationController
  def views
    @post_id = params[:id]
    render 'posts/views'
  end
end
