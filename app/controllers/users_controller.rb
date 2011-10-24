class UsersController < ApplicationController
  respond_to :json, :html

  def index
  end

  # Ideally this would be the 'create' action. But this
  # is kinda funky because the callback from last.fm is always a GET request
  def new
    @user = User.find_or_create_by_token(params[:token])
    set_current_user @user
    unless @user.rhapsody_inactive?
      redirect_to user_path(@user)
    end
  end

  def show
    @user = current_user
    respond_with(@user)
  end

  def create
    @user = current_user
    @user.update_attributes(params[:user])
    redirect_to user_path(@user)
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    redirect_to user_path(@user)
  end
end
