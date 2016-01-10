class AddTypeToPins < ActiveRecord::Migration
  def change
    add_column :pins, :type, :integer
  end
end
