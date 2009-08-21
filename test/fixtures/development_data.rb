puts "Before importing this sample data for the development database make sure you've done a rake db:populate first."


# People

puts "Creating sample people."

mr = Title.find_by_name("Mr")
mrs = Title.find_by_name("Mrs")
dr = Title.find_by_name("Dr")

male = Gender.find_by_name("Male")
female = Gender.find_by_name("Female")

christianity = Religion.find_by_name("Christianity")
buddhism = Religion.find_by_name("Buddhism")

english = Language.find_by_name("English")
spanish = Language.find_by_name("Spanish")
chinese = Language.find_by_name("Chinese")
french = Language.find_by_name("French")

single = MaritalStatus.find_by_name("Single")
married = MaritalStatus.find_by_name("Married")
divorced = MaritalStatus.find_by_name("Divorced")

it = IndustrySector.find_by_name("IT")
wholesale = IndustrySector.find_by_name("Wholesale")
manufacturing = IndustrySector.find_by_name("Manufacturing")

australia = Country.find_by_short_name("Australia")
china = Country.find_by_short_name("China")
india = Country.find_by_short_name("India")

puts "Creating Robert Tingle"
robert_tingle = Person.create(
  :custom_id => "89567",
  :industry_sector_id => it.id,
  :primary_title_id => mr.id,
  :first_name => "Robert",
  :family_name => "Tingle",
  :preferred_name => "Bob",
  :gender_id => male.id,
  :marital_status_id => single.id,
  :religion_id => christianity.id,
  :origin_country_id => australia.id,
  :residence_country_id => australia.id,
  :nationality_id => australia.id,
  :language_id => english.id,
  :other_language_id => spanish.id,
  :onrecord_since => 1.year.ago
)

puts "Creating Jackie Chan"
jackie_chan = Person.create(
  :custom_id => "548514",
  :industry_sector_id => wholesale.id,
  :primary_title_id => dr.id,
  :first_name => "Jackie",
  :family_name => "Chan",
  :preferred_name => "The Dragon",
  :gender_id => male.id,
  :marital_status_id => married.id,
  :religion_id => buddhism.id,
  :origin_country_id => china.id,
  :residence_country_id => china.id,
  :nationality_id => china.id,
  :language_id => china.id,
  :other_language_id => english.id,
  :onrecord_since => 100.days.ago
)

puts "Creating Sarah Clarkson"
sarah_clarkson = Person.create(
  :custom_id => "257854",
  :industry_sector_id => manufacturing.id,
  :primary_title_id => mrs.id,
  :first_name => "Sarah",
  :family_name => "Clarkson",
  :gender_id => female.id,
  :marital_status_id => divorced.id,
  :religion_id => buddhism.id,
  :origin_country_id => china.id,
  :residence_country_id => australia.id,
  :nationality_id => china.id,
  :language_id => chinese.id,
  :other_language_id => english.id,
  :onrecord_since => 36.days.ago
)

puts "Creating Bill Woo"
bill_woo = Person.create(
  :custom_id => "7846552",
  :industry_sector_id => manufacturing.id,
  :primary_title_id => mr.id,
  :second_title_id => dr.id,
  :first_name => "William",
  :family_name => "Woo",
  :preferred_name => "Bill",
  :gender_id => male.id,
  :marital_status_id => divorced.id,
  :religion_id => buddhism.id,
  :origin_country_id => china.id,
  :residence_country_id => australia.id,
  :nationality_id => china.id,
  :language_id => chinese.id,
  :other_language_id => english.id,
  :onrecord_since => 212.days.ago
)

puts "Creating Karen Smith"
karen_smith = Person.create(
  :custom_id => "3258714",
  :industry_sector_id => it.id,
  :primary_title_id => mrs.id,
  :second_title_id => dr.id,
  :first_name => "Karen",
  :family_name => "Smith",
  :gender_id => female.id,
  :marital_status_id => single.id,
  :religion_id => christianity.id,
  :origin_country_id => australia.id,
  :residence_country_id => india.id,
  :nationality_id => australia.id,
  :language_id => english.id,
  :other_language_id => french.id,
  :onrecord_since => 586.days.ago
)

# MasterDoc Data

puts "Creating sample MasterDoc data."

mdmmt = MasterDocMetaMetaType.create :name => "Licences"

mdmt = MasterDocMetaType.create :name => "Airplane", :master_doc_meta_meta_type => mdmmt
boeing_747 = MasterDocType.create :name => "Boeing 747", :master_doc_meta_type => mdmt
boeing_737 = MasterDocType.create :name => "Boeing 737", :master_doc_meta_type => mdmt
paper_aeroplane = MasterDocType.create :name => "Paper aeroplane", :master_doc_meta_type => mdmt

mdmt = MasterDocMetaType.create :name => "Road Vehicles", :master_doc_meta_meta_type => mdmmt
huge_truck = MasterDocType.create :name => "Huge Truck", :master_doc_meta_type => mdmt
little_truck = MasterDocType.create :name => "Little Truck", :master_doc_meta_type => mdmt
car = MasterDocType.create :name => "Car", :master_doc_meta_type => mdmt

mdmmt = MasterDocMetaMetaType.create :name => "Identification"

mdmt = MasterDocMetaType.create :name => "Government Issued", :master_doc_meta_meta_type => mdmmt
passport = MasterDocType.create :name => "Passport", :master_doc_meta_type => mdmt
drivers_licence = MasterDocType.create :name => "Drivers Licence", :master_doc_meta_type => mdmt
national_id_card = MasterDocType.create :name => "National ID Card", :master_doc_meta_type => mdmt


puts "Creating passport for Robert Tingle"
MasterDoc.create(
  :entity => robert_tingle,
  :master_doc_type_id => passport.id,
  :doc_number => "L74383956",
  :name_on_doc => "Robert R Tingle",
  :issue_organisation => "Australian Government",
  :issue_place => "Sydney, Australia"
)

puts "Creating drivers licence for Robert Tingle"
MasterDoc.create(
  :entity => robert_tingle,
  :master_doc_type_id => drivers_licence.id,
  :doc_number => "12643116",
  :name_on_doc => "Robert Rick Tingle",
  :issue_organisation => "RTA",
  :issue_state => "NSW"
)

puts "Creating Boeing 747 licence for Jackie Chan."
MasterDoc.create(
  :entity => jackie_chan,
  :master_doc_type_id => boeing_747.id,
  :doc_number => "65875545325358",
  :name_on_doc => "Jackie Chan",
  :issue_organisation => "Boeing Corporation"
)

# Contacts

puts "Creating sample contacts."

email_work = ContactType.find(:first, :conditions => ["contact_meta_type_id = ? and name = 'Work'", ContactMetaType.find_by_name("Email").id])
email_personal = ContactType.find(:first, :conditions => ["contact_meta_type_id = ? and name = 'Personal'", ContactMetaType.find_by_name("Email").id])
phone_mobile = ContactType.find(:first, :conditions => ["contact_meta_type_id = ? and name = 'Mobile'", ContactMetaType.find_by_name("Phone").id])
phone_home = ContactType.find(:first, :conditions => ["contact_meta_type_id = ? and name = 'Home'", ContactMetaType.find_by_name("Phone").id])
website_business = ContactType.find(:first, :conditions => ["contact_meta_type_id = ? and name = 'Business'", ContactMetaType.find_by_name("Website").id])



puts "Creating email for Sarah Clarkson"
Email.create(
  :contactable => sarah_clarkson,
  :contact_type_id => email_personal.id,
  :value => "sarah.clarkson@gmail.com"
)

puts "Creating email for Jackie Chan"
Email.create(
  :contactable => jackie_chan,
  :contact_type_id => email_work.id,
  :value => "the_dragon@hotmail.com"
)

puts "Creating Phone for Robert Tingle"
Phone.create(
  :contactable => robert_tingle,
  :contact_type_id => phone_mobile.id,
  :value => "0410258698"
)

puts "Creating Phone for Jackie Chan"
Phone.create(
  :contactable => robert_tingle,
  :contact_type_id => phone_home.id,
  :pre_value => "02",
  :value => "82564521"
)

puts "Creating Phone for Karen Smith"
Phone.create(
  :contactable => karen_smith,
  :contact_type_id => phone_mobile.id,
  :value => "0458759565"
)

puts "Creating Website for Jackie Chan"
Website.create(
  :contactable => jackie_chan,
  :contact_type_id => website_business.id,
  :value => "www.jackiechan.com"
)


# Addresses

# Keywords

# Masterdocs

#Organisations
puts "Createing Organisation for ABC"
Organisation.create(
  :full_name => "ABC"
)