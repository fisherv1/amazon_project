class ReceiptType < Tag

  acts_as_list

  belongs_to :receipt_meta_type, :class_name => "ReceiptMetaType", :foreign_key => "tag_type_id"

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :tag_type_id

  after_create :assign_priority
  before_destroy :reorder_priority

  private

  def assign_priority
    self.move_to_bottom
  end

  def reorder_priority
    self.remove_from_list
  end

end