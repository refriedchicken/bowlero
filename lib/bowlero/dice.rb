module Bowlero
  module Dice
    # Rolls the Strike Die: returns 1-5 (pins) or :strike
    def self.roll_strike_die
      roll = rand(1..6)
      roll == 6 ? :strike : roll
    end

    # Rolls the Split Die: returns 1-5 (pins) or :split
    def self.roll_split_die
      roll = rand(1..6)
      roll == 6 ? :split : roll
    end

    # Rolls the Split Resolution Die: returns :open (1-4) or :spare (5-6)
    def self.roll_split_resolution_die
      roll = rand(1..6)
      roll <= 4 ? :open : :spare
    end

    # Rolls the Spare Resolution Die: returns :spare (1-4) or :open (5-6)
    def self.roll_spare_resolution_die
      roll = rand(1..6)
      roll <= 4 ? :spare : :open
    end
  end
end 