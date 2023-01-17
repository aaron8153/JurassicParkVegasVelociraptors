class CreateCages < ActiveRecord::Migration[7.0]
  def change
    create_table :cages do |t|
      t.string :name
      t.integer :max_capacity
      t.boolean :power_status

      t.timestamps
    end
  end
end
