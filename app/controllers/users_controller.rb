class UsersController < ApplicationController
  respond_to :html, :json
  def new
    @new_user = User.new
  end
  
  def index
    @users = User.all
  end
  
  def edit
    @edit_user = User.find(params[:id])
    respond_modal_with @edit_user
  end
  
  def update
    edit_user = User.find(params[:id])
    authorize edit_user, :president
    edit_user.update(user_update_params)
    respond_to do |format|
	  format.html {redirect_to '/users', :flash => { :success => "#{edit_user.first_name} #{edit_user.last_name} updated."}}
	  format.json {head :ok}
    end
  end
  
  def waiver
    change_user = User.find(params[:id])
    authorize change_user, :alt_auth
    change_user.update({:waiver=>!change_user.waiver})
    respond_to do |format|
	  format.html {redirect_to '/users'}
	  format.json {head :ok}
    end
  end
  
  def dues
    change_user = User.find(params[:id])
    authorize change_user, :alth_auth
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
    authorize changing_user, :president
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
  
  private
  def user_update_params
    #params.require(:equipment).permit(:typeid, :itemname, :description)
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end