class UsersController < ApplicationController
  respond_to :html, :json
  def new
    @new_user = User.new
  end
  
  def index
    @users = User.all
  end
  
  def waiver
    change_user = User.find(params[:id])
    change_user.update({:waiver=>!change_user.waiver})
    respond_to do |format|
	  format.html {redirect_to '/users'}
	  format.json {head :ok}
    end
  end
  
  def dues
    change_user = User.find(params[:id])
    change_user.update({:dues=>!change_user.dues})
    respond_to do |format|
	  format.html {redirect_to '/users'}
	  format.json {head :ok}
    end
  end
  
  def positions
    @changing_user = User.find(params[:id])
    respond_modal_with @changing_user
  end
  
  def assign_position
    changing_user = User.find(params[:id])
    if (params[:positions_for_user])
      @position_changes = Position.where("id in (#{(params[:positions_for_user]).join(",")})")
      position_param = Hash.new
      position_param[:users_id] = params[:id]
      @position_changes.update_all(position_param)
    else
      @position_changes = Position.where("users_id=#{changing_user.id} and title not like 'president'")
      position_param = Hash.new
      position_param[:users_id] = nil
      @position_changes.update_all(position_param)
    end
    respond_to do |format|
	  format.html {redirect_to '/users', :flash => { :success => "#{changing_user.first_name} #{changing_user.last_name} updated positions to:  #{@position_changes.to_a.collect{|t| t.title.capitalize}.join(",")}"}}
	  format.json {head :ok}
    end
  end
end