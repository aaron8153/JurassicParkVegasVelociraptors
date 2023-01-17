class CreateDinosaurs < ActiveRecord::Migration[7.0]
  def change
    create_table :dinosaurs do |t|
      t.string :name
      t.references :species, null: false, foreign_key: true
      t.references :cage, null: false, foreign_key: true

      t.timestamps
    end
  end
end
