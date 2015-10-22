class AddReviewLevelToCards < ActiveRecord::Migration
  def change
    add_column :cards, :review_level, :integer, default: 0
    add_column :cards, :error_counter, :integer, default: 0
  end
end
