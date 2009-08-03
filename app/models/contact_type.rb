class ContactType < ActiveRecord::Base

#--
################ 
#  Associations
################
#++
  
  has_many :contacts
  belongs_to :contact_meta_type

#--
################ 
#  Validations
################
#++  

  validates_presence_of :name
  
end
