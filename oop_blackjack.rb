require 'pry'

class Card
  attr_accessor :suit, :value
  
  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def to_s
    "#{value} of #{suit}"
  end
end

class Deck
  attr_accessor :cards

  def initialize(number)
    @cards = [] 
    ["Hearts", "Diamonds", "Spades", "Clubs"].each do |suit|
      ["2", "3", "4", "5", "6", "7", "8", "9", "10", 'Jack', 'Queen', 'King', 'Ace'].each do |value|
        @cards << Card.new(suit, value)
      end
    end
    @num_decks = cards * number
    shuffle
  end

  def shuffle
    cards.shuffle!
  end

  def deal
    cards.pop
  end

  def size
    cards.size
  end
end

class Hand
  attr_accessor :cards_in_hand, :values, :score

  def initialize
    @cards_in_hand = []
  end

  def receive_cards(deck)
    cards_in_hand << deck.deal
  end

  def to_s
    puts cards_in_hand
  end

  def calculate
    @values = cards_in_hand.map { |card| card.value }

    @score = 0
    values.each do |value|
      if value == 'Ace'
        @score += 11
      elsif value.to_i == 0
        @score += 10
      else
        @score += value.to_i
      end
    end

    if @score > 21 && values.include?('Ace')
      @score -= 10
    end
    @score
  end

  def bust?
    @score = calculate
    @score > 21
  end

  def blackjack?
    @score = calculate
    @score == 21
  end
end

class Player
  attr_accessor :name
  
  def initialize(name)
    @name = name
  end

  def hit(hand, deck)
     hand.receive_cards(deck)
  end

  def show_cards(hand)
    puts "#{name}'s hand:"
    puts "#{hand.to_s}Score => #{hand.calculate}"
    puts
  end

end

class Dealer < Player
  attr_accessor :name
  
  def initialize
    @name = "Dealer"
  end

  def hide_card(hand)

  end
end

class Game
  attr_accessor :player, :dealer, :deck, :player_hand, :dealer_hand

  def initialize
    @player = Player.new(get_name)
    @dealer = Dealer.new
    @deck = Deck.new(get_decks)
  end

  def get_name
    puts "Welcome to Blackjack!"
    puts "What's your name?"
    new_name = gets.chomp
  end

  def get_decks
    puts "How many decks do you want to play with #{player.name}? Enter between 1-8."
    decks = gets.chomp.to_i
    if decks < 1 || decks > 8
      puts "Please enter a number of decks between 1 and 8."
      get_decks
    end
    decks
  end

  def deal_cards
    @player_hand = Hand.new
    @dealer_hand = Hand.new
    player_hand.receive_cards(deck)
    dealer_hand.receive_cards(deck)
    player_hand.receive_cards(deck)
    dealer_hand.receive_cards(deck)
    puts "__________________________________Dealing_____________________________________"
    player.show_cards(player_hand)
    dealer.show_cards(dealer_hand)
  end

  def win
    puts "Congratulations! You won!"
  end

  def lose
    puts "Sorry! You lost."
  end

  def push
    puts "Push..."
  end

  def blackjack_check(hand1, hand2)
    if hand1.blackjack? == true && hand2.blackjack? == false
      puts "Blackjack!"
      win
      puts
      play_again
    elsif hand1.blackjack? == false && hand2.blackjack? == true
      puts "Dealer got blackjack."
      lose
      puts
      play_again
    elsif hand1.blackjack? == true && hand2.blackjack? == true
      push
      puts
      play_again
    else
      hit_or_stay
    end
  end

  def compare_hands
    if player_hand.calculate > dealer_hand.calculate
      puts win
      play_again
    elsif player_hand.calculate < dealer_hand.calculate
      puts lose
      play_again
    else 
      puts push
      play_again
    end 
  end

  def dealer_turn
    if dealer_hand.calculate < 17
      dealer.hit(dealer_hand, deck) 
      puts "Dealer hits..."
      dealer.show_cards(dealer_hand)
      if dealer_hand.bust? == true
        puts "Dealer busted."
        win
        puts
        play_again
      else
        dealer_turn
      end
    else
      puts "Dealer stays..."
      dealer.show_cards(dealer_hand)
      compare_hands
    end
  end

  def hit_or_stay
    puts "Would you like to hit or stay?"
    move = gets.chomp
    
    if !["hit","stay"].include?(move)
      puts "Error. Please enter 'hit' or 'stay'."
      hit_or_stay
    end

    if move == "hit"
      player.hit(player_hand, deck)
      player.show_cards(player_hand)
      if player_hand.bust? == true
        puts "You busted." 
        lose
        puts
        play_again
      end

      if player_hand.calculate < 21
        hit_or_stay
      end

      if player_hand.blackjack? == true
        dealer_turn
      end
    end
    
    if move == "stay"
      player.show_cards(player_hand)
      dealer_turn
    end
  end

  def play_again
    puts "Do you want to play again?"
    puts "Enter 'yes'/'no'."
    response = gets.chomp
    
    if !["yes", "no"].include?(response)
      puts "Please enter 'yes'/'no'."
      play_again
    end
    
    if response == "yes"
      @play = true
      play
    else
      @play = false
      exit
    end
  end

  def play
    @play = true
    while @play == true
      deal_cards
      #binding.pry
      blackjack_check(player_hand, dealer_hand)
      hit_or_stay 
      dealer_turn
      compare_hands   
    end 
  end  


end

blackjack = Game.new

blackjack.play










