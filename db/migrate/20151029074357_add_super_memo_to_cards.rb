class AddSuperMemoToCards < ActiveRecord::Migration
  def change
    add_column :cards, :memo_interval, :integer, default: nil
    add_column :cards, :memo_ef, :decimal, default: 2.5
  end
end
