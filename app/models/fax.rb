class Fax < Contact
  #acts_as_list :column => "priority_number"
  #--
  ################
  #  Assocations
  ################
  #++

  belongs_to :person
  #--
  ################
  #  Callbacks
  ################
  #++
  before_save :update_priority
  before_destroy :update_priority_before_destroy
  #--
  ################
  #  Methods
  ################
  #++
  # Return the prefix value of a phone number
  # Convenience method to access pre_value
  def prefix
    read_attribute(:pre_value)
  end

  # Return the the main number of a phone number
  # Convenience method to access value
  def number
    read_attribute(:value)
  end

  # Return the suffix of a phone number
  # Convenice method to access post_value
  def suffix
    read_attribute(:post_value)
  end

  # Return a concatenation of all numbers joined by a space
  def complete_number
    "#{self.pre_value} #{self.value} #{self.post_value}".squeeze(" ").strip
  end

  def preferrence_day_times
    "Monday(#{prefer_time(self.monday_hours)}) " +
      "Tuesday(#{prefer_time(self.tuesday_hours)}) " +
      "Wednesday(#{prefer_time(self.wednesday_hours)}) " +
      "Thursday(#{prefer_time(self.thursday_hours)}) " +
      "Friday(#{prefer_time(self.friday_hours)}) " +
      "Saturday(#{prefer_time(self.saturday_hours)}) " +
      "Sunday(#{prefer_time(self.sunday_hours)})"
  end
  def prefer_time(value)
    case value
    when "0"
      return "Not Available"
    when "1"
      return "Business Hours"
    when "2"
      return "After Hours"
    when "3"
      return "Any Time"
    end
  end

  private
  def update_priority
    #self.move_to_bottom
    self.priority_number = self.contactable.faxes.length+1 if self.new_record?
  end

  def update_priority_before_destroy
    priority_number = self.priority_number
    Fax.transaction do
      self.contactable.faxes.each { |fax|
        if (fax.priority_number > priority_number)
          fax.priority_number -= 1
          fax.save!
        end
      }
    end
  end
end
