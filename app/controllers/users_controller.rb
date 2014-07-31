class UsersController < ApplicationController

  before_action :authenticate_user!, :correct_user

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb.bak
      format.xml { render :xml => @user }
    end
  end

  protected

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless current_user.id == @user.id
  end

end