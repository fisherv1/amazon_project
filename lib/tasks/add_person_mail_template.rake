namespace :db do
  desc "Add Person Mail template"
  task :add_person_mail_template => :environment do
    puts "Run Patch all person mail template ..."
    PersonMailTemplate.all.each do |i|
      i.destroy
    end
   puts "Initializing Membership template"

PersonMailTemplate.create :name=>"Membership Initiate Template", :body=>"<p>hi,</p>
<p>Your application has been&nbsp; initiated.</p>
<p>&nbsp;</p>
<p>Amazon</p>" , :status => true,:to_be_removed =>false ,:template_category_id=> TemplateCategory.find_by_name('Membership').id

PersonMailTemplate.create :name=>"Membership Review Template", :body=>"<p>hi,</p>
<p>Your application has been&nbsp; reviewed.</p>
<p>&nbsp;</p>
<p>Amazon</p>" , :status => true,:to_be_removed =>false ,:template_category_id=> TemplateCategory.find_by_name('Membership').id

PersonMailTemplate.create :name=>"Membership Finalize Template", :body=>"<p>hi,</p>
<p>Your application has been&nbsp; finalized.</p>
<p>&nbsp;</p>
<p>Amazon</p>" , :status => true,:to_be_removed =>false ,:template_category_id=> TemplateCategory.find_by_name('Membership').id
    puts "DONE"

  end


  puts "Run Patch all person email template"
      PersonEmailTemplate.all.each do |i|
      i.destroy
    end
   puts "Initializing Membership template"

PersonEmailTemplate.create :name=>"Membership Initiate Email Template", :body=>"<p>hi,</p>
<p>Your application has been&nbsp; initiated.</p>
<p>&nbsp;</p>
<p>Amazon</p>" , :status => true,:to_be_removed =>false ,:template_category_id=> TemplateCategory.find_by_name('Membership').id

end
