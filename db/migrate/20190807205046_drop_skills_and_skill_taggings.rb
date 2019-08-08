class DropSkillsAndSkillTaggings < ActiveRecord::Migration[5.2]
  def change
    execute "DROP TABLE #{:skills} CASCADE"
  end
end
