class EquipmentPolicy < ApplicationPolicy
  def update?
    
  end
  
  def eqrequest?
    user.dues? and user.waiver?
  end
  
  def armorer?
    user.id == Position.where("title like 'armorer'").select("users_id")[0][:users_id]
  end
  
  def general_add_eq?
    Position.where("title in ('armorer', 'president', 'treasurer')").select("users_id").to_a.collect{|t| t.users_id}.contains(user.id)
  end
end