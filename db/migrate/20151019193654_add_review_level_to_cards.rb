class AddReviewLevelToCards < ActiveRecord::Migration
  def up
    add_column :cards, :review_level, :integer
    add_column :cards, :error_counter, :integer
    say_with_time "Default values for new fields..." do
      Card.all.each do |c|
        c.review_level = 0
        c.error_counter = 0
        c.save!
      end
    end
  end

  def down
    remove_column :cards, :review_level, :integer
    remove_column :cards, :error_counter, :integer
  end
end
