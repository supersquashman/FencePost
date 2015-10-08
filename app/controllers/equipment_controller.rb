class EquipmentController < ApplicationController
  respond_to :html, :json
  def index
    @equipment = Equipment.joins("join (select id, status_desc from statuses) s on s.id=equipment.status_id", "join (select id, description as type from equipment_types) et on et.id=equipment.equipment_type_id").
		 select("equipment.*, status_desc, type") 
    @position = Position.where("users_id=#{current_user.id}").select("id,title").collect{|p| p.title}
    @curr_user = current_user.id
  end
  
  def new
    @new_item=Equipment.new
    respond_modal_with @new_item
  end
  
  def create
    @new_item = Equipment.new(inventory_params)
    #@new_item.status=1
    #respond_modal_with @new_item, location: "/equipment"
    respond_to do |format|
      if @new_item.save
	#flash[:success] = "#{@new_item.description} added to inventory"
        format.html { redirect_to '/equipment', :flash => { :success => "'#{@new_item.description}' added to inventory."} }
	format.html {redirect_to '/equipment'}
        format.json { render action: 'show', status: :created, location: '/equipment' }
        # added:
        format.js   { render action: 'show', status: :created, location: '/equipment' }
      else
        format.html { render action: 'new' }
        format.json { render json: @new_item.errors, status: :unprocessable_entity }
        # added:
        format.js   { render json: @new_item.errors, status: :unprocessable_entity }
      end
    end
  end
    
    def edit
     @current_item = Equipment.find(params[:id])
     respond_modal_with @current_item
  end
  
  def update
     @current_item = Equipment.find(params[:id])
     
     @current_item.update(inventory_params)
     respond_to do |format|
	  format.html {redirect_to '/equipment', :flash => { :success => "'#{@current_item.description}' updated."}}
	  format.json {head :ok}
      end
  end
  
  def destroy
      @remove_item = Equipment.find(params[:id])
      @remove_item.destroy
      
      respond_to do |format|
	  format.html {redirect_to '/equipment', :flash => { :error => "'#{@remove_item.description}' deleted."}}
	  format.json {head :ok}
      end
  end

  private

  def inventory_params
    #params.require(:equipment).permit(:typeid, :itemname, :description)
    params.require(:equipment).permit(:status_id, :description, :equipment_type_id, :parts)
  end
end