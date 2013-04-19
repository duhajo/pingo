class CreateWorkers < ActiveRecord::Migration
  def change
    create_table :workers do |t|
      t.string :name
      t.string :pass
      t.string :email

      t.timestamps
    end
  end
end
