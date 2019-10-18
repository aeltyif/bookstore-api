class AddBiographyToAuthor < ActiveRecord::Migration[5.1]
  def up
    add_column :authors, :biography, :text
  end

  def down
    remove_column :authors, :biography
  end
end
