class SystemLog < ActiveRecord::Base

  
  belongs_to :login_account
  validates_presence_of :message


  def self.system_log_entries(user_name, start_date, end_date, status)

    SystemLog.find_by_sql(["SELECT s.id AS \"id\", s.created_at AS \"created_at\", s.login_account_id AS \"login_account_id\", s.ip_address AS \"ip_address\", s.controller AS \"controller\", s.action AS \"action\", s.message AS \"message\" FROM system_logs s, login_accounts l WHERE l.user_name ILIKE ? AND s.created_at >= ? AND s.created_at <= ? AND s.status ILIKE ? ORDER BY s.created_at ASC", user_name, start_date, end_date, status])
  end
  

end
