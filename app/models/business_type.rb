class BusinessType < AmazonSetting

  acts_as_list

  validates_presence_of :name
  validates_uniqueness_of :name, :message => "A business type already exists with the same name."

  after_create :assign_priority
  before_destroy :reorder_priority

  def self.active_business_type
    @business_type = BusinessType.find(:all, :conditions => ["status = true"], :order => 'name')
  end

  private

  def assign_priority
    self.move_to_bottom
  end

  def reorder_priority
    self.remove_from_list
  end
  
end
