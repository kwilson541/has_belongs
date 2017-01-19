class RemoveAuthorFromPens < ActiveRecord::Migration[5.0]
  def change
    remove_reference :pens, :author, foreign_key: true
  end
end
