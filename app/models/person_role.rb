class PersonRole < ActiveRecord::Base
  acts_as_list :column => 'sequence_no'
  belongs_to :role_player, :class_name => 'Person', :foreign_key => 'person_id'
  belongs_to :role_assigner, :class_name => 'Person', :foreign_key => 'assigned_by'
  belongs_to :role_approver, :class_name => 'Person', :foreign_key => 'approved_by'
  belongs_to :role_superviser, :class_name => 'Person', :foreign_key => 'supervised_by'
  belongs_to :role_manager, :class_name => 'Person', :foreign_key => 'managed_by'

  belongs_to :role

  validates_presence_of :role_id,:assigned_by,:person_id,:start_date

  validates_uniqueness_of :role_id, :scope => :person_id
 
  validate :role_must_exist
  validate :person_must_exist


  def self.find_person_role(id,role_id)
    PersonRole.find(:first,:conditions=>["person_id = ? and role_id = ?",id,role_id])
  end

  def self.find_all_person_role(id,role_id)
    PersonRole.find(:all,:conditions=>["person_id = ? and role_id = ?",id,role_id])
  end

  def role_must_exist
    errors.add(:role_id, "You must specify a role that exists.") if (role_id && Role.find_by_id(role_id).nil?)
  end

  def person_must_exist
    errors.add(:person_id, "You must specify a person that exists.") if (person_id && Person.find_by_id(person_id).nil?)
    errors.add(:role_assigner, "You must specify a person that exists.") if (assigned_by && Person.find_by_id(assigned_by).nil?)
    errors.add(:role_approver, "You must specify a person that exists.") if (approved_by && Person.find_by_id(approved_by).nil?)
    errors.add(:role_superviser, "You must specify a person that exists.") if (supervised_by && Person.find_by_id(supervised_by).nil?)
    errors.add(:role_manager, "You must specify a person that exists.") if (managed_by && Person.find_by_id(managed_by).nil?)
  end



end
