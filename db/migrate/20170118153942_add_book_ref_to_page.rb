class AddBookRefToPage < ActiveRecord::Migration[5.0]
  def change
    add_reference :pages, :book, foreign_key: true
  end
end
