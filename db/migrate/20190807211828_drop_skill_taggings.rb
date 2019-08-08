class DropSkillTaggings < ActiveRecord::Migration[5.2]
  def change
    drop_table(:skill_taggings)
  end
end
