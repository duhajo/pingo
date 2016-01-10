class CreatePinsFiles < ActiveRecord::Migration
  def self.up
    create_table :pins_files do |t|
      t.references :user
      t.references :pin
      t.string :file
      t.string :title
      t.text :description

      t.timestamps
    end

    add_index :pins_files, [:pin_id, :user_id]
  end

  def self.down
    drop_table :pins_files
  end
end
