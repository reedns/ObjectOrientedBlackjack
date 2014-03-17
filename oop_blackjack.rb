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
      ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Queen", "King", "Ace"].each do |value|
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

class Player
  attr_accessor :name, :hand, :values, :score

  def initialize(name)
    @name = name
    @hand = []
  end

  def receive_cards(deck)
    hand << deck.deal
  end

  def to_s
    puts hand
  end

  def discard
    hand.pop until hand == []
  end

  def show_cards
    puts "#{name}'s hand:"
    puts "#{to_s}Score => #{calculate}"
    puts "=============================================================================="
  end

  def hide_card
    @card_showing = hand[1]
    puts "Dealer's hand:"
    puts "??????"
    puts "#{@card_showing.to_s}"
    puts "Score => ??"
  end

  def calculate
    @values = hand.map { |card| card.value }

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
    score
  end

  def bust?
    score > 21
  end

  def blackjack?
    score == 21
  end
end

class Game
  attr_accessor :player, :dealer, :deck, :player_hand, :dealer_hand

  def initialize
    @player = Player.new(get_name)
    @dealer = Player.new("Dealer")
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

  def separation
    puts "==============================================================================" 
  end

  def deal_cards
    player.receive_cards(deck)
    dealer.receive_cards(deck)
    player.receive_cards(deck)
    dealer.receive_cards(deck)
    puts "Dealing".center(75)
    separation
    player.show_cards
    dealer.hide_card
    separation
  end

  def win
    puts "Congratulations! You won!"
    separation
    play_again
  end

  def lose
    puts "Sorry! You lost."
    separation
    play_again
  end

  def push
    puts "Push..."
    separation
    play_again
  end

  def compare_hands
    puts "Final Hands:"
    puts
    puts player.show_cards
    puts dealer.show_cards
    if player.calculate > dealer.calculate
      puts win
    elsif player.calculate < dealer.calculate
      puts lose
    else 
      puts push
    end 
  end

  def dealer_turn
    if dealer.calculate < 17
      dealer.receive_cards(deck) 
      puts "Dealer hits..."
      puts
      dealer.show_cards
      if dealer.bust? == true
        puts "Dealer busted."
        win
      else
        dealer_turn
      end
    else
      puts "Dealer stays..."
      separation
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
      player.receive_cards(deck)
      separation
      player.show_cards
      if player.bust? == true
        puts "You busted." 
        lose
        puts
      end

      if player.calculate < 21
        hit_or_stay
      end

      if player.blackjack? == true
        puts
        dealer_turn
      end
    end
    
    if move == "stay"
      separation
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
      player.discard
      dealer.discard
      play
    else
      exit
    end
  end

  def play
    @play = true
    while @play == true
      deal_cards
      if player.blackjack? == true
        puts "Blackjack!"
        win
      else
        hit_or_stay
      end 

      if dealer.blackjack? == true
        dealer.show_cards
        puts "Dealer got blackjack."
        lose
      else
        dealer_turn
      end
      compare_hands   
    end 
  end  
end

Game.new.play
