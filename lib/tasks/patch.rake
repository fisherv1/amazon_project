namespace :db do
  desc "Run patch after restore database"
  task :patch => [:environment, "db:migrate", "initial_current_user", 
    "add_template_categories",
    "add_workplaces",
    "add_payroll_methods",
    "add_payment_methods",
    "add_tag_meta_meta_type",
    "add_table_meta_meta_type",
    "add_membership_status",
    "add_person_mail_template",
    "modify_client_setups_level", 
    "add_family_id"] do
    puts "Patch Done!"
  end
end