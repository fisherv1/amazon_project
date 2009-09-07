ContactMetaMetaType.create :name => "Email",    :status => true
ContactMetaMetaType.create :name => "Fax",    :status => true
ContactMetaMetaType.create :name => "Phone",    :status => true
ContactMetaMetaType.create :name => "Website",    :status => true

email = ContactMetaMetaType.find_by_name("Email")
fax = ContactMetaMetaType.find_by_name("Fax")
phone = ContactMetaMetaType.find_by_name("Phone")
website = ContactMetaMetaType.find_by_name("Website")

ContactMetaType.create :name => "Work",   :tag_meta_type_id => email.id,    :status => true
ContactMetaType.create :name => "Personal",   :tag_meta_type_id => email.id,    :status => true
ContactMetaType.create :name => "Mobile",   :tag_meta_type_id => phone.id,    :status => true
ContactMetaType.create :name => "Home",   :tag_meta_type_id => phone.id,    :status => true
ContactMetaType.create :name => "Business",   :tag_meta_type_id => website.id,    :status => true
ContactMetaType.create :name => "Business",   :tag_meta_type_id => fax.id,    :status => true