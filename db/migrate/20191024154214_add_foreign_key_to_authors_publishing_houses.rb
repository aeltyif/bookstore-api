class AddForeignKeyToAuthorsPublishingHouses < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :authors, :books, on_delete: :cascade
    add_foreign_key :publishing_house, :books, on_delete: :cascade
  end
end
