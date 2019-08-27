class UsersController < ApplicationController
  def index
    @users = User.all.order({ :username => :asc })

    respond_to do |format|
      format.json do
        render({ :json => @users.as_json })
      end

      format.html do
        render({ :template => "users/index.html" })
      end
    end
  end

  def show
    the_username = params.fetch(:rt_username)
    @user = User.where({ :username => the_username }).at(0)

    respond_to do |format|
      format.json do
        render({ :json => @user.as_json })
      end

      format.html do
        render({ :template => "users/show.html.erb" })
      end
    end
  end

  def create
    user = User.new

    user.username = params.fetch(:qs_username, nil)
    user.private = params.fetch(:qs_private, nil)
    user.likes_count = params.fetch(:qs_likes_count, 0)
    user.comments_count = params.fetch(:qs_comments_count, 0)
    
    user.save
    
    respond_to do |format|
      format.json do
        render({ :json => @user.as_json })
      end

      format.html do
        redirect_to("/users/#{user.username}")
      end
    end
  end

  def update
    the_id = params.fetch(:rt_user_id)
    user = User.where({ :id => the_id }).at(0)


    user.username = params.fetch(:qs_username, user.username)
    user.private = params.fetch(:qs_private, nil)
    user.likes_count = params.fetch(:qs_likes_count, user.likes_count)
    user.comments_count = params.fetch(:qs_comments_count, user.comments_count)
    
    user.save

    respond_to do |format|
      format.json do
        render({ :json => user.as_json })
      end

      format.html do
        redirect_to("/users/#{user.username}")
      end
    end
  end

  def destroy
    username = params.fetch(:rt_username)
    user = User.where({ :username => username }).at(0)

    user.destroy

    render({ :json => user.as_json })
  end

  def liked_photos
    username = params.fetch(:rt_username)
    @user = User.where({ :username => username }).at(0)
  
    respond_to do |format|
      format.json do
        render({ :json => @user.liked_photos.as_json })
      end

      format.html do
        render({ :template => "users/liked_photos.html.erb" })
      end
    end
  end

  def own_photos
    username = params.fetch(:rt_username)
    user = User.where({ :username => username }).at(0)

    render({ :json => user.own_photos.as_json })
  end

  def feed
    username = params.fetch(:rt_username)
    @user = User.where({ :username => username }).at(0)
    
    respond_to do |format|
      format.json do
        render({ :json => @user.feed.as_json })
      end

      format.html do
        render({ :template => "users/feed.html.erb" })
      end
    end
  end

  def discover
    username = params.fetch(:rt_username)
    @user = User.where({ :username => username }).at(0)

    respond_to do |format|
      format.json do
        render({ :json => @user.discover.as_json })
      end

      format.html do
        render({ :template => "users/discover.html.erb" })
      end
    end
  end

end
