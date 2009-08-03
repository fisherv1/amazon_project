class Address < ActiveRecord::Base

  acts_as_list :column => "priority_number"
  #--
  ################
  #  Associations
  ################
  #++

  belongs_to :addressable, :polymorphic => true
  belongs_to :address_type, :class_name => "AddressType", :foreign_key => "address_type_id"
  belongs_to :country

  #--
  ################
  #  Validations
  ################
  #++

  validates_presence_of :address_type_id
  validate :fields_cannot_all_be_empty
  
  #--
  ################
  #  Callbacks
  ################
  #++

  after_create :update_priority
  before_destroy :update_priority_before_destroy
  ################
  #  Delegation
  ################
  #++

  # 
  delegate :short_name, :to => :country, :prefix => true, :allow_nil => true, :default => ""

  # Return the address type
  delegate :name, :to => :address_type, :prefix => true, :allow_nil => true, :default => ""

  #--
  ################
  #  Methods
  ################
  #++

  # Returns the first line containing the
  # building name, unit number, street number and street name
  def first_line
    "#{self.building_name} #{self.suite_unit} #{self.street_number} #{self.street_name}".squeeze(" ").strip
  end
  
  # Returns the second line containing the
  # town, district and region
  def second_line
    "#{self.town} #{self.district} #{self.region}".squeeze(" ").strip
  end
  
  # Returns the third line containing the
  # state, post code and country
  def third_line
    "#{self.state} #{self.postal_code} #{self.country_short_name}".squeeze(" ").strip
  end
  
  #--
  ###################
  #  Private Methods
  ###################
  #++
  
  private
  
  def fields_cannot_all_be_empty
    errors.add_to_base("This address is invalid because all fields are empty") if building_name.blank? and
      suite_unit.blank? and
      street_number.blank? and
      street_name.blank? and
      town.blank? and
      state.blank? and
      postal_code.blank? and
      time_zone.blank? and
      map_reference.blank? and
      bar_code.blank?
  end
  
  def update_priority
    self.move_to_bottom
  end

  def update_priority_before_destroy
    self.remove_from_list
  end

end
