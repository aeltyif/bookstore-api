class AddIssueIdToAuthor < ActiveRecord::Migration[5.1]
  def change
    add_column :authors, :issue_id, :integer, unique: true
  end
end
