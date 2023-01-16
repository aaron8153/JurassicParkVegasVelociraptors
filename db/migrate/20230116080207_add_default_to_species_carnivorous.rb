class AddDefaultToSpeciesCarnivorous < ActiveRecord::Migration[7.0]
  def change
    change_column :species, :carnivorous, :boolean, :default => false
  end
end
