Factory.define :doc_tag_meta_type, :class => "MasterDocMetaMetaType" do |f|
  f.sequence(:id) { |n| n }
  f.sequence(:name) { |n| "name #{n}" }
end

Factory.define :group_tag_meta_type, :class => "GroupMetaMetaType" do |f|
  f.sequence(:id) { |n| n }
  f.sequence(:name) { |n| "name #{n}" }
end
