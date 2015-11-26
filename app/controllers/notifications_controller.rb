class NotificationsController < ApplicationController
  
  def new
    @new_notification = Notification.new
  end
  
  def index
    @notifications = Notification.where("to_user_id == #{current_user.id}").joins("join (select id, (first_name||' '||last_name) as name from users) tu on tu.id=notifications.to_user_id",
                                                                                  "join (select id, (first_name||' '||last_name) as name from users) fu on fu.id=notifications.from_user_id")
				 .select("notifications.*, tu.name as to_user, fu.name as from_user")
    @notifications.update_all(:viewed => true)
#     @notifications = Notification.all
    @approvals = EquipmentRequest.where("request_status_id == #{RequestStatus.where("status_desc like 'Pending'").select("id")[0][:id]}")
		  .joins("join (select id, request_type_description from request_types) as rt on rt.id = checkout_table.request_types_id",
		         "join (select id, description from equipment) as eq on eq.id = checkout_table.equipment_id",
		         "join (select id, (first_name+' '+last_name) as name from users) as u on u.id = checkout_table.users_id ")
		  .select("rt.request_type_description as rtdesc, eq.description as equipment_desc, checkout_table.*")
  end
  
  def approve
    @curr_user = current_user.id
    current_request = EquipmentRequest.find(params[:id])
    approve_param = Hash.new
    approve_param[:request_status_id] = RequestStatus.where("status_desc like 'Approved'").select("id")[0][:id]
    approve_param[:time_closed] = Time.now
    current_request.update(approve_param)
    
    update_action = RequestType.find(current_request.request_types_id).request_type_description
    case update_action
    when "Checkout"
      notif_params = Hash.new
      notif_params[:from_user_id] = @curr_user
      notif_params[:timestamp] = Time.now
      notif_params[:message] = "Your request to check out #{Equipment.find(current_request.equipment_id).description} has been Approved."
      notif_params[:viewed] = false
      notif_params[:to_user_id] = current_request.users_id
      new_notification = Notification.new(notif_params)
      new_notification.save
      
      update_param = Hash.new
      update_param[:users_id] = current_request[:users_id]
      update_equipment = Equipment.find(current_request[:equipment_id])
      update_equipment.update(update_param)
      
      deny_related_requests = EquipmentRequest.where("equipment_id=#{current_request[:equipment_id]} and users_id!=#{current_request.users_id}")
      deny_related_requests.each do |request|
	deny_private_request(request)
      end
    when "Return"
      notif_params = Hash.new
      notif_params[:from_user_id] = @curr_user
      notif_params[:timestamp] = Time.now
      notif_params[:message] = "Your return of #{Equipment.find(current_request.equipment_id).description} has been verified."
      notif_params[:viewed] = false
      notif_params[:to_user_id] = current_request.users_id
      new_notification = Notification.new(notif_params)
      new_notification.save
      
      update_param = Hash.new
      update_param[:users_id] = ""
      update_equipment = Equipment.find(current_request[:equipment_id])
      update_equipment.update(update_param)
    when "Repair"
      requests_to_update = EquipmentRequest.where("equipment_id=#{current_request.equipment_id} and request_types_id=#{current_request.request_types_id} and request_status_id=#{current_request.request_status_id}")
      requests_to_update_params = Hash.new
      requests_to_update_params[:request_status_id] = RequestStatus.where("status_desc like 'Approved'").select("id")[0][:id]
      requests_to_update_params[:time_closed] = Time.now
      requests_to_update.update_all(requests_to_update_params)
      
      notif_params = Hash.new
      notif_params[:from_user_id] = @curr_user
      notif_params[:timestamp] = Time.now
      notif_params[:message] = "#{Equipment.find(current_request.equipment_id).description} has been marked as not working."
      notif_params[:viewed] = false
      notif_params[:to_user_id] = current_request.users_id
      new_notification = Notification.new(notif_params)
      new_notification.save
      
      update_param = Hash.new
      update_param[:status_id] = Status.where("status_desc like 'Not Working'").select("id")[0][:id]
      update_equipment = Equipment.find(current_request[:equipment_id])
      update_equipment.update(update_param)
    end
    respond_to do |format|
	  format.html {redirect_to '/notifications', :flash => { :success => ""}}
	  format.json {head :ok}
      end
  end
  
  def deny
    @curr_user = current_user.id
    current_request = EquipmentRequest.find(params[:id])
    deny_private_request(current_request)
#     deny_param = Hash.new
#     deny_param[:request_status_id] = RequestStatus.where("status_desc like 'Denied'").select("id")[0][:id]
#     deny_param[:time_closed] = Time.now
#     current_request.update(deny_param)
    respond_to do |format|
	  format.html {redirect_to '/notifications', :flash => { :success => ""}}
	  format.json {head :ok}
      end
  end
  
  private
  
  def deny_private_request(private_request)
    @curr_user = current_user.id
    current_request = private_request
    deny_param = Hash.new
    deny_param[:request_status_id] = RequestStatus.where("status_desc like 'Denied'").select("id")[0][:id]
    deny_param[:time_closed] = Time.now
    current_request.update(deny_param)
    
    update_action = RequestType.find(current_request.request_types_id).request_type_description
    case update_action
    when "Checkout"
      notif_params = Hash.new
      notif_params[:from_user_id] = @curr_user
      notif_params[:timestamp] = Time.now
      notif_params[:message] = "Your request to check out #{Equipment.find(current_request.equipment_id).description} has been Denied."
      notif_params[:viewed] = false
      notif_params[:to_user_id] = current_request.users_id
      new_notification = Notification.new(notif_params)
      new_notification.save
	
    when "Return"
      notif_params = Hash.new
      notif_params[:from_user_id] = @curr_user
      notif_params[:timestamp] = Time.now
      notif_params[:message] = "Your return of #{Equipment.find(current_request.equipment_id).description} has been marked as invalid."
      notif_params[:viewed] = false
      notif_params[:to_user_id] = current_request.users_id
      new_notification = Notification.new(notif_params)
      new_notification.save
    when "Repair"
      requests_to_update = EquipmentRequest.where("equipment_id=#{current_request.equipment_id} and request_type_ids=#{current_request.request_types_id} and request_status_id=#{current_request.request_status_id}")
      requests_to_update_params[:request_status_id] = RequestStatus.where("status_desc like 'Denied'").select("id")[0][:id]
      requests_to_update_params[:time_closed] = Time.now
      requests_to_update.update_all(requests_to_update_params)
      
      notif_params = Hash.new
      notif_params[:from_user_id] = @curr_user
      notif_params[:timestamp] = Time.now
      notif_params[:message] = "Your repair request for #{Equipment.find(current_request.equipment_id).description} has been Denied.  This equipment is still marked as working."
      notif_params[:viewed] = false
      notif_params[:to_user_id] = current_request.users_id
      new_notification = Notification.new(notif_params)
      new_notification.save
    end
  end
  
  def notification_params
    #params.require(:equipment).permit(:typeid, :itemname, :description)
    params.require(:equipment).permit(:status_id, :description, :equipment_type_id, :parts)
  end
end