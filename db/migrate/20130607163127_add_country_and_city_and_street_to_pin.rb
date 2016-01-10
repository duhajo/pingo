class AddCountryAndCityAndStreetToPin < ActiveRecord::Migration
  def change
    add_column :pins, :country, :string
    add_column :pins, :city, :string
    add_column :pins, :street, :string
  end
end
