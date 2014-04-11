class AddPictureToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :picture, :string
  end
end
