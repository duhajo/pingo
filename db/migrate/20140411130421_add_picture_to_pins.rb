class AddPictureToPins < ActiveRecord::Migration
  def change
    add_column :pins, :picture, :string
  end
end
