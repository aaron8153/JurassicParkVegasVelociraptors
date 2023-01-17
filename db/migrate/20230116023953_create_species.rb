class CreateSpecies < ActiveRecord::Migration[7.0]
  def change
    create_table :species do |t|
      t.string :name
      t.boolean :carnivorous

      t.timestamps
    end
  end
end
