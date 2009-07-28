class Employment < ActiveRecord::Base
  belongs_to :employee, :class_name => 'Person', :foreign_key => 'person_id'
  belongs_to :recruiter, :class_name => 'Person', :foreign_key => 'hired_by'
  belongs_to :supervisor, :class_name => 'Person', :foreign_key => 'report_to'
  belongs_to :terminator, :class_name => 'Person', :foreign_key => 'terminated_by'
  belongs_to :organisation

end
