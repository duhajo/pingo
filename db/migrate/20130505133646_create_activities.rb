class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.integer :type
      t.text :content
      t.references :user
      t.references :job
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt

      t.timestamps
    end
  end
  
  def self.down
    drop_table :activities
  end
end
