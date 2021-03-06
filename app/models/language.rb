class Language < AmazonSetting

  acts_as_list

  validates_presence_of :name
  validates_uniqueness_of :name, :message => "A language already exists with the same name."

  after_create :assign_priority
  before_destroy :reorder_priority
  default_scope :order => 'name'

  def self.active_language
    @language = Language.find(:all, :conditions => ["status = true"], :order => 'name')
  end

  private

  def assign_priority
    self.move_to_bottom
  end

  def reorder_priority
    self.remove_from_list
  end
  
end
