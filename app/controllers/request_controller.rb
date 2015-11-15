class RequestController < ApplicationController
  
  def new
    @new_request = EquipmentRequest.new
  end
  
  def index
    @notifications = Notification.where("to_user_id == #{current_user.id}")
    @approvals = EquipmentRequest.where("request_status_id == 0")
  end
  
  private

  def request_params
    #params.require(:equipment).permit(:typeid, :itemname, :description)
    params.require(:equipment).permit(:status_id, :description, :equipment_type_id, :parts)
  end
end