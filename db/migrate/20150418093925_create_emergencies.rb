class CreateEmergencies < ActiveRecord::Migration
  def change
    create_table :emergencies do |t|
      t.string :code, index: true
      t.integer :fire_severity
      t.integer :police_severity
      t.integer :medical_severity
      t.boolean :full_response, index: true, default: false
      t.timestamp :resolved_at, index: true, default: nil

      t.timestamps null: false
    end
  end
end
