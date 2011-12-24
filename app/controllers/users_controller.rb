class UsersController < ApplicationController
  before_filter :check_for_session, :only => [:index, :new, :create]
  respond_to :json, :html

  def index
  end

  def new
    @user = \
    if lastfm_session
      User.new(
        :session_key     => lastfm_session.key,
        :lastfm_username => lastfm_session.username
      )
    else
      User.new
    end

    respond_with(@user)
  end

  def show
    @user = current_user
    respond_with(@user)
  end

  def create
    @user = User.create(params[:user])

    if @user.valid?
      set_current_user @user
      redirect_to @user
    else
      render :new
    end
  end

  def update
    @user = current_user
    @user.update_attributes(params[:user])
    redirect_to @user
  end

private

  # Ideally these methods would be placed in a separate module, but since this is a one-controller
  # app, separation of concerns is not such an issue.
  def check_for_session
    # If we still have their lastfm session token, log them in and redirect
    if lastfm_session && @user = User.find_by_lastfm_username(lastfm_session.username)
      set_current_user @user
      redirect_to @user
    end
  end

  def lastfm_token
    cookies[:lastfm_token] ||= {
      :value   => Rockstar::Auth.new.token,
      # TODO: Does last.fm invalidate tokens sooner than 2 years? API docs are unclear.
      :expires => 2.years.from_now
    }

    cookies[:lastfm_token]
  end

  def lastfm_session
    return @lastfm_session if @lastfm_session

    begin
      @lastfm_session = Rockstar::Auth.new.session(lastfm_token)
    # Rockstar throws a NoMethodError if the session is not valid. Yay!
    rescue NoMethodError
      nil
    end
  end
end
