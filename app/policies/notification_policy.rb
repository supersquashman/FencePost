class NotificationsPolicy < ApplicationPolicy
  
  def update?
    
  end
  
  def armorer?
    user.id == Position.where("title like 'armorer'").select("users_id")[0][:users_id]
  end
end