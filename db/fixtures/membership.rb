puts "Initializing Membership template"

PersonMailTemplate.create :name=>"Membership Initiate Template", :body=>"<p>hi,</p>
<p>Your application has been&nbsp; initiated.</p>
<p>&nbsp;</p>
<p>Amazon</p>" , :status => true,:to_be_removed =>false ,:mail_merge_category_id=> MailMergeCategory.find_by_name('Membership').id

PersonMailTemplate.create :name=>"Membership Review Template", :body=>"<p>hi,</p>
<p>Your application has been&nbsp; reviewed.</p>
<p>&nbsp;</p>
<p>Amazon</p>" , :status => true,:to_be_removed =>false ,:mail_merge_category_id=> MailMergeCategory.find_by_name('Membership').id

PersonMailTemplate.create :name=>"Membership Finalize Template", :body=>"<p>hi,</p>
<p>Your application has been&nbsp; finalized.</p>
<p>&nbsp;</p>
<p>Amazon</p>" , :status => true,:to_be_removed =>false ,:mail_merge_category_id=> MailMergeCategory.find_by_name('Membership').id