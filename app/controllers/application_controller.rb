class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  
  def respond_modal_with(*args, &blk)
    options = args.extract_options!
    options[:responder] = ModalResponder
    respond_with *args, options, &blk
  end
  
  def index
     @note_count = Notification.count("to_user_id == #{current_user.id}") + EquipmentRequest.count("request_status_id == 0")
     puts @note_count
  end
end
