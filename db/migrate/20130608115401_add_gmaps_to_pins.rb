class AddGmapsToPins < ActiveRecord::Migration
  def change
    add_column :pins, :gmaps, :boolean
  end
end
