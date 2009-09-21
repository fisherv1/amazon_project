class CreateGroupLists < ActiveRecord::Migration
  def self.up
    create_table :group_lists do |t|
      t.integer :tag_id
      t.integer :list_header_id

      t.timestamps

    end
  end

  def self.down
    drop_table :group_lists
  end
end
