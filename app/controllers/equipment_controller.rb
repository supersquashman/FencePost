class EquipmentController < ApplicationController
  
  def index
    @equipment = Equipment.all
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
    
    def edit
     @current_item = Equipment.find(params[:equipmentid])
     respond_modal_with @current_item
  end
  
  def update
     @current_item = Equipment.find(params[:equipmentid])
     
     @current_item.update(inventory_params)
     respond_to do |format|
	  format.html {redirect_to '/equipment', :flash => { :success => "'#{@current_item.description}' updated."}}
	  format.json {head :ok}
      end
  end
  
  def destroy
      @remove_item = Equipment.find(params[:equipmentid])
      @remove_item.destroy
      
      respond_to do |format|
	  format.html {redirect_to '/equipment', :flash => { :error => "'#{@remove_item.description}' deleted."}}
	  format.json {head :ok}
      end
  end

  private

  def inventory_params
    #params.require(:equipment).permit(:typeid, :itemname, :description)
    params.require(:equipment)
  end
end