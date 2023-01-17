class AddSpeciesToCages < ActiveRecord::Migration[7.0]
  def change
    add_belongs_to :cages, :species, foreign_key: true, index: true, null: true
  end
end