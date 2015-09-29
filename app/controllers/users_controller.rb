class UsersController < ApplicationController
  
  def new
    @new_user = User.new
  end
  
  def index
    @users = User.all
  end
end