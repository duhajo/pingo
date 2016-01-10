class CreatePins < ActiveRecord::Migration
  def self.up
    create_table :pins do |t|
      t.string :title
      t.text :description
      t.date :deadline
      t.integer :user_id
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt

      t.timestamps
    end
  end

  def self.down
    drop_table :pins
  end
end
