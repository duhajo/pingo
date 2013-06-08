class AddGmapsToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :gmaps, :boolean
  end
end
