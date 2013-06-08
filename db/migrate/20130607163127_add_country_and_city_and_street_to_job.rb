class AddCountryAndCityAndStreetToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :country, :string
    add_column :jobs, :city, :string
    add_column :jobs, :street, :string
  end
end
