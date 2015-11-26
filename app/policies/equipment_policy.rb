class EquipmentPolicy < ApplicationPolicy
  def update?
    
  end
  
  def eqrequest?
    user.dues? and user.waiver?
  end
  
  def armorer?
    user.id == Position.where("title like 'armorer'").select("users_id")[0][:users_id]
  end
end