class EquipmentController < ApplicationController
  respond_to :html, :json
  def index
    @equipment = Equipment.where("users_id IS NULL").joins("join (select id, status_desc from statuses) s on s.id=equipment.status_id", "join (select id, description as type from equipment_types) et on et.id=equipment.equipment_type_id").
		 select("equipment.*, status_desc, type") 
    @curr_user = current_user.id
    @borrowed_eq = Equipment.where("#{@position.include?("armorer") ? "users_id IS NOT NULL" : "users_id = #{@curr_user}"}").joins("join (select id, status_desc from statuses) s on s.id=equipment.status_id", "join (select id, description as type from equipment_types) et on et.id=equipment.equipment_type_id").
		  select("equipment.*, status_desc, type")
#     @requested_eq = EquipmentRequest.where("users_id == #{@curr_user}").joins("join (select id as 'requestid' from request_statuses where status_desc like 'Pending') rs on rs.id=request_status_id", "join(select request_type_description, id from request_types) as rt on rt.id=request_types_id").select("id")[0][:id]}) as si on si.requestid=checkout_table.request_status_id").select("checkout_table.*")
    #{RequestType.where("request_type_description like 'Repair'")
    @requested_eq = EquipmentRequest.where("users_id == #{@curr_user} and  request_types_id!=#{RequestType.where("request_type_description like 'Repair'").select("id")[0][:id]}")
				    .joins("join (select id from request_statuses where status_desc like 'Pending') rs on rs.id=request_status_id", 
                                           "join(select request_type_description, id from request_types) as rt on rt.id=request_types_id")
				    .select("checkout_table.*, rt.request_type_description as rt_desc")
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
     authorize @current_item, :armorer?
     @current_item.update(inventory_params)
     respond_to do |format|
	  format.html {redirect_to '/equipment', :flash => { :success => "'#{@current_item.description}' updated."}}
	  format.json {head :ok}
      end
  end
  
  def destroy
      @remove_item = Equipment.find(params[:id])
      authorize @remove_item, :armorer?
      @remove_item.destroy
      
      respond_to do |format|
	  format.html {redirect_to '/equipment', :flash => { :error => "'#{@remove_item.description}' deleted."}}
	  format.json {head :ok}
      end
  end
  
  def eqrequest
    current_item = Equipment.find(params[:id])
    authorize current_item
    @curr_user = current_user.id
    cust_params = Hash.new
    cust_params[:equipment_id] = current_item.id
    cust_params[:users_id] = @curr_user
    cust_params[:time_opened] = Time.now
    cust_params[:request_status_id] = RequestStatus.where("status_desc like 'Pending'").select("id")[0][:id]
    cust_params[:request_types_id] = RequestType.where("request_type_description like 'Checkout'").select("id")[0][:id]
    new_request = EquipmentRequest.new(cust_params)
    new_request.save
#     notif_params = Hash.new
#     notif_params[:from_user_id] = @curr_user
#     notif_params[:timestamp] = cust_params[:time_requested]
#     notif_params[:message] = "#{@curr_user} has requested #{@current_item.description}"
#     notif_params[:viewed] = false
#     temp= Position.where("title like 'armorer'").select("users_id")
#     puts "armorer id is #{temp.collect{|u| u.users_id}}"
#     notif_params[:to_user_id] = temp.collect{|u| u.users_id}[0]
#     @new_notification = Notification.new(notif_params)
#     @new_notification.save
    
    respond_to do |format|
	  format.html {redirect_to '/equipment', :flash => { :success => "'#{current_item.description}' has been requested."}}
	  format.json {head :ok}
      end
  end
  
  def eqreturn
      current_item = Equipment.find(params[:id])
      @curr_user = current_user.id
      cust_params = Hash.new
      cust_params[:equipment_id] = current_item.id
      cust_params[:users_id] = @curr_user
      cust_params[:time_opened] = Time.now
      cust_params[:request_status_id] = RequestStatus.where("status_desc like 'Pending'").select("id")[0][:id]
      cust_params[:request_types_id] = RequestType.where("request_type_description like 'Return'").select("id")[0][:id]
      new_request = EquipmentRequest.new(cust_params)
      new_request.save
    respond_to do |format|
	  format.html {redirect_to '/equipment', :flash => { :success => "'#{current_item.description}' has been marked as returned.  Pending verification."}}
	  format.json {head :ok}
      end
  end
  
  def canceleqrequest
    current_item = Equipment.find(params[:id])
    @curr_user = current_user.id
    current_request = EquipmentRequest.find(EquipmentRequest.where("equipment_id = #{current_item.id} and users_id = #{@curr_user} and time_closed is null").select("id")[0][:id])
    cust_params = Hash.new
    cust_params[:request_status_id] = RequestStatus.where("status_desc like 'Withdrawn'").select("id")[0][:id]
    cust_params[:time_closed] = Time.now
    puts cust_params
    current_request.update(cust_params)
    
    respond_to do |format|
	  format.html {redirect_to '/equipment', :flash => { :success => "'#{current_item.description}' request has been withdrawn."}}
	  format.json {head :ok}
      end
  end
  
  def eqrepair
    current_item = Equipment.find(params[:id])
    @curr_user = current_user.id
    cust_params = Hash.new
    cust_params[:equipment_id] = current_item.id
    cust_params[:users_id] = @curr_user
    cust_params[:time_opened] = Time.now
    cust_params[:request_status_id] = RequestStatus.where("status_desc like 'Pending'").select("id")[0][:id]
    cust_params[:request_types_id] = RequestType.where("request_type_description like 'Repair'").select("id")[0][:id]
    new_request = EquipmentRequest.new(cust_params)
    new_request.save
    respond_to do |format|
	  format.html {redirect_to '/equipment', :flash => { :success => "'#{current_item.description}' has been marked as needing repair.  Pending verification."}}
	  format.json {head :ok}
      end
  end

  private

  def inventory_params
    #params.require(:equipment).permit(:typeid, :itemname, :description)
    params.require(:equipment).permit(:status_id, :description, :equipment_type_id, :parts)
  end
end