module ModelHelper
  def show_models_data(where)
    puts where + " All Cards(" + Card.all.count.to_s + ")"
    Card.all.each do |c|
      puts c.original_text + " @ " + c.deck.name + " of " + c.deck.user.email
    end

    puts where + " All Users(" + User.all.count.to_s + ")"
    User.all.each do |u|
      print u.email
      print "(" + u.current_deck.name + ")" unless u.current_deck.nil?
      print ":\n"
      u.decks.each do |d|
        d.cards.each do |c|
          puts "  Card " + c.original_text + " in deck " + d.name
        end
      end
    end

    puts where + " All Decks(" + Deck.all.count.to_s + ")"
    Deck.all.each do |d|
      puts "Deck named " + d.name + " of user " + d.user.email + " have cards:"
      d.cards.each do |c|
        puts c.original_text
      end
    end
  end
end
