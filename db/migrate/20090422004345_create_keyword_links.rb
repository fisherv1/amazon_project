class CreateKeywordLinks < ActiveRecord::Migration
  def self.up
    create_table :keyword_links do |t|
      t.integer :keyword_id
      t.integer :taggable_id
      t.string :taggable_type
      
      t.timestamps
    end
  end

  def self.down
    drop_table :keyword_links
  end
end