class AddCountryAndCityAndDistrictAndRadiusToUser < ActiveRecord::Migration
  def change
    add_column :users, :country, :string
    add_column :users, :city, :string
    add_column :users, :district, :string
    add_column :users, :radius, :integer
  end
end
