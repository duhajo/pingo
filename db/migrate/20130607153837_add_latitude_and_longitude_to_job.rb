class AddLatitudeAndLongitudeToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :latitude, :float
    add_column :jobs, :longitude, :float
  end
end
