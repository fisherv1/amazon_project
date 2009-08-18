class RelationshipType < AmazonSetting

  acts_as_list

  validates_presence_of :name
  validates_uniqueness_of :name, :message => "A realtionship type already exists with the same name."

  after_create :assign_priority
  before_destroy :reorder_priority

  def self.active_relationship_type
    @relationship_type = RelationshipType.find_all_by_status(true)
  end

  private

  def assign_priority
    self.move_to_bottom
  end

  def reorder_priority
    self.remove_from_list
  end
  
end
