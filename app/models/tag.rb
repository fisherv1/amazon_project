class Tag < ActiveRecord::Base

  belongs_to :tag_type
  has_many :group_type, :class_name => 'PersonGroup', :foreign_key => 'tag_id'

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:type, :tag_type_id], :case_sensitive => false

  default_scope :order => "name ASC"

  def self.distinct_types_of_tags
    @tags = Tag.find(:all, :select => "DISTINCT type")
    results = ""
    @tags.each { |setting| results += "<option value='" + "#{setting.type}" + "'>" + "#{setting.type}" + "</option>" }
    return results
  end
  

end
