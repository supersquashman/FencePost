class UserPolicy < ApplicationPolicy
  def update?
    
  end
  
  def president?
    user.id == Position.where("title like 'president'").select("users_id")[0][:users_id]
  end
  
  def alt_auth?
    Position.where("title in ('president', 'treasurer')").select("users_id").to_a.collect{|t| t.users_id}.include?(user.id)    
  end
end