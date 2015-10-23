class NotificationsController < ApplicationController
  
  def new
    @new_notification = Notification.new
  end
  
  def index
    @notifications = Notification.where("to_user_id == #{current_user.id}")
    @approvals = EquipmentRequest.where("request_status_id == 0")
  end
end