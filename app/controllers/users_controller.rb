class UsersController < ApplicationController
  
  def new
    @new_user = User.new
  end
  
end