class CreateJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_join_table :bacons, :piggies do |t|
      # t.index [:barn_id, :field_id]
      # t.index [:field_id, :barn_id]
    end
  end
end