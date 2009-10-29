class MaintenanceController < ApplicationController

  # This relies heavily on the backup script in lib/tasks/backup_db.rake.
  # It assumes that in the specified backup directory the only thing the directory
  # contains are folder in the following format:
  # <year>-<month>-<day>_<24hour><min>-<sec>
  # eg 2009-10-10_01-00-05
  # and that inside that directory there should be a backup file of the database.

  def system_backup


  end


  def system_restore
    backup_directory = "/home/rails/database/backup"
    @backups = Array.new
    # if ( File.exists?(backup_directory) && File.directory?(backup_directory) && File.readable?(backup_directory) )
    if (true)
      # available_backups = (Dir.entries(backup_directory) - ["..", "."]).stort
      available_backups = ["2009-10-10_01-00-05", "2009-10-26_01-00-07", "2009-10-25_01-00-10", "2009-10-22_01-00-06", "2009-10-16_01-00-07", "2009-10-11_01-00-06", "2009-10-14_01-00-05", "2009-10-20_01-00-06", "2009-10-18_01-00-06", "2009-10-15_01-00-06", "2009-10-21_01-00-06", "2009-10-12_01-00-06", "2009-10-19_01-00-09", "2009-10-13_01-00-06", "2009-10-28_01-00-06", "2009-10-17_01-00-06", "2009-10-24_01-00-07", "2009-10-23_01-00-06", "2009-10-27_01-00-06", "2009-10-29_01-00-06"].sort.reverse
      for backup in available_backups do
        backup = backup_directory_tidy(backup)
        @backups << backup unless backup.empty?
      end
    end
  end

  private

  def backup_directory_tidy(directory)
    #The input should match 2009-10-10_01-00-05 and return
    # Sat 10 Oct 2009 01:00:05 AM
    # If the string cannot be parsed it should return blank

    return "" unless directory =~ /^\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2}$/
    date_time = directory.split(/_/)
    directory_date = date_time.first.to_date.strftime('%a %d %b %Y')
    directory_time = date_time.second.gsub(/-/, ':')

    return "#{directory_date} #{directory_time}"


  end

end
