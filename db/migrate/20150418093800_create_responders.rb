class CreateResponders < ActiveRecord::Migration
  def change
    create_table :responders do |t|
      t.string :emergency_code, default: nil
      t.string :type, index: true
      t.string :name, index: true
      t.integer :capacity
      t.boolean :on_duty, default: false

      t.timestamps null: false
    end
  end
end
