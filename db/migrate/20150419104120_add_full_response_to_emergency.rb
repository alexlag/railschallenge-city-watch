class AddFullResponseToEmergency < ActiveRecord::Migration
  def change
    add_column :emergencies, :full_response, :boolean, index: true, default: false
  end
end
