class CreateResponders < ActiveRecord::Migration
  def change
    create_table :responders do |t|
      t.references :emergency, index: true, default: nil
      t.string :type, index: true, null: false
      t.string :name, index: true, null: false
      t.integer :capacity, null: false
      t.boolean :on_duty, index: true, default: false

      t.timestamps null: false
    end
  end
end
