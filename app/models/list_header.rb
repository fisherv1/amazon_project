class ListHeader < ActiveRecord::Base



  belongs_to :query_header
  has_many :list_details
  has_many :user_lists
  has_many :group_lists

  has_many :group_types, :through => :group_lists, :uniq => true
  has_many :players, :through => :list_details, :source => :person

  validates_uniqueness_of :name, :case_sensitive => false
  validates_presence_of :name, :query_header

  def formatted_info
    "#{self.name} - #{self.description} : #{self.list_size} records"
  end
end
