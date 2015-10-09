class AddCurrentDeckRefToUser < ActiveRecord::Migration
  def change
    add_reference :users, :deck, index: true, foreign_key: true
    # add_column :users, :current_deck_id, :integer
    # add_index :users, :current_deck_id

    reversible do |dir|
      dir.up do
        say_with_time "Changing tables to use Default deck..." do
          User.all.each do |u|
            u.update_columns(deck_id: Deck.create(name: "Default deck", user: u));
            u.cards.each do |c|
              c.deck = u.deck
              c.save!
            end
          end
        end
      end

      dir.down do
        say_with_time "Removing Decks implementation" do
          User.all.each do |u|
            user_current_deck = u.deck
            u.decks.each do |deck|
              deck.cards.each do |c|
                c.user = u
                c.deck = nil
                c.save!
              end
            end
            u.update_columns(deck_id: nil);
            Deck.destroy(user_current_deck)
          end
        end
      end
    end

    remove_column :cards, :user_id, :integer
  end
end
