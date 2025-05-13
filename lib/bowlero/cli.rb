module Bowlero
  class CLI
    def self.start
      # Array of fun bowling pun names
      PUN_NAMES = [
        'Pin Diesel', 'Bowl Job', "Livin' on a Spare", 'Alley McBowl',
        'Split Happens', 'Gutterball Guru', 'The Pincredible Hulk',
        'Strike Tyson', 'Bowliver Twist', 'Rolling Thunder'
      ]

      def clear_screen
        system('clear') || system('cls')
      end

      def prompt(message)
        print "#{message} "
        gets.chomp
      end

      def main_menu
        loop do
          clear_screen
          puts '🎳 Welcome to Bowlero! 🎳'
          puts '1. Start Game'
          puts '2. Exit'
          print 'Choose an option: '
          choice = gets.chomp.strip
          case choice
          when '1'
            start_game
          when '2'
            puts 'Thanks for playing Bowlero!'
            exit(0)
          else
            puts 'Invalid option. Press Enter to try again.'
            gets
          end
        end
      end

      def start_game
        clear_screen
        default_name = PUN_NAMES.sample
        name = prompt("Enter your player name [#{default_name}]:")
        name = default_name if name.strip.empty?
        puts "\nWelcome, #{name}! Let's bowl a full game."

        frames = []
        10.times do |frame_num|
          puts "\n--- Frame #{frame_num + 1} ---"
          frame = Bowlero::Frame.new(frame_number: frame_num + 1)
          if frame_num < 9
            # Regular frames (1-9)
            strike_die = Bowlero::Dice.roll_strike_die
            split_die = Bowlero::Dice.roll_split_die
            if strike_die == :strike
              puts "🎳 STRIKE! You knocked down all 10 pins on the first roll!"
              frame.result = :strike
              frame.first_roll = 10
              frame.second_roll = 0
              frame.pins = 10
              frames << frame
              next
            end
            # Not a strike, so sum pins
            if split_die == :split
              split_value = 6
              total_pins = strike_die + split_value
              frame.split = true
              puts "You knocked down #{strike_die} pins and left a SPLIT! (Split worth 6, Total: #{total_pins} pins)"
            else
              split_value = split_die
              total_pins = strike_die + split_value
              frame.split = false
              puts "You knocked down #{strike_die} and #{split_die} pins (Total: #{total_pins})"
            end
            frame.first_roll = total_pins > 10 ? 10 : total_pins
            if total_pins >= 10
              puts "That's a STRIKE by pin count!"
              frame.result = :strike
              frame.second_roll = 0
              frame.pins = 10
            else
              # Second roll
              if split_die == :split
                split_res = Bowlero::Dice.roll_split_resolution_die
                frame.split_converted = (split_res == :spare)
                if split_res == :spare
                  puts "You converted the split for a SPARE!"
                  frame.result = :spare
                  frame.second_roll = 10 - frame.first_roll
                  frame.pins = 10
                else
                  puts "Open frame. Some pins left standing."
                  frame.result = :open
                  frame.second_roll = 0
                  frame.pins = frame.first_roll
                end
              else
                spare_res = Bowlero::Dice.roll_spare_resolution_die
                if spare_res == :spare
                  puts "You picked up the spare!"
                  frame.result = :spare
                  frame.second_roll = 10 - frame.first_roll
                  frame.pins = 10
                else
                  puts "Open frame. Some pins left standing."
                  frame.result = :open
                  frame.second_roll = 0
                  frame.pins = frame.first_roll
                end
              end
            end
            frames << frame
          else
            # 10th frame special logic
            puts "10th frame! You can get up to 3 rolls if you strike or spare."
            # First roll
            strike_die = Bowlero::Dice.roll_strike_die
            split_die = Bowlero::Dice.roll_split_die
            if strike_die == :strike
              puts "🎳 STRIKE! You knocked down all 10 pins on the first roll!"
              frame.first_roll = 10
              frame.result = :strike
              # Second roll (bonus)
              strike_die2 = Bowlero::Dice.roll_strike_die
              split_die2 = Bowlero::Dice.roll_split_die
              if strike_die2 == :strike
                puts "🎳 STRIKE! Second roll in 10th frame is a strike!"
                frame.second_roll = 10
              else
                if split_die2 == :split
                  split_value2 = 6
                  total_pins2 = strike_die2 + split_value2
                  puts "You knocked down #{strike_die2} pins and left a SPLIT! (Split worth 6, Total: #{total_pins2} pins)"
                  frame.second_roll = total_pins2 > 10 ? 10 : total_pins2
                else
                  split_value2 = split_die2
                  total_pins2 = strike_die2 + split_value2
                  puts "You knocked down #{strike_die2} and #{split_die2} pins (Total: #{total_pins2})"
                  frame.second_roll = total_pins2 > 10 ? 10 : total_pins2
                end
              end
              # Third roll (bonus)
              strike_die3 = Bowlero::Dice.roll_strike_die
              split_die3 = Bowlero::Dice.roll_split_die
              if strike_die3 == :strike
                puts "🎳 STRIKE! Third roll in 10th frame is a strike!"
                frame.third_roll = 10
              else
                if split_die3 == :split
                  split_value3 = 6
                  total_pins3 = strike_die3 + split_value3
                  puts "You knocked down #{strike_die3} pins and left a SPLIT! (Split worth 6, Total: #{total_pins3} pins)"
                  frame.third_roll = total_pins3 > 10 ? 10 : total_pins3
                else
                  split_value3 = split_die3
                  total_pins3 = strike_die3 + split_value3
                  puts "You knocked down #{strike_die3} and #{split_die3} pins (Total: #{total_pins3})"
                  frame.third_roll = total_pins3 > 10 ? 10 : total_pins3
                end
              end
            else
              # Not a strike on first roll
              if split_die == :split
                split_value = 6
                total_pins = strike_die + split_value
                puts "You knocked down #{strike_die} pins and left a SPLIT! (Split worth 6, Total: #{total_pins} pins)"
                frame.split = true
              else
                split_value = split_die
                total_pins = strike_die + split_value
                puts "You knocked down #{strike_die} and #{split_die} pins (Total: #{total_pins})"
                frame.split = false
              end
              frame.first_roll = total_pins > 10 ? 10 : total_pins
              # Second roll
              if total_pins >= 10
                puts "That's a STRIKE by pin count!"
                frame.result = :strike
                # Two more rolls
                strike_die2 = Bowlero::Dice.roll_strike_die
                split_die2 = Bowlero::Dice.roll_split_die
                if strike_die2 == :strike
                  puts "🎳 STRIKE! Second roll in 10th frame is a strike!"
                  frame.second_roll = 10
                else
                  if split_die2 == :split
                    split_value2 = 6
                    total_pins2 = strike_die2 + split_value2
                    puts "You knocked down #{strike_die2} pins and left a SPLIT! (Split worth 6, Total: #{total_pins2} pins)"
                    frame.second_roll = total_pins2 > 10 ? 10 : total_pins2
                  else
                    split_value2 = split_die2
                    total_pins2 = strike_die2 + split_value2
                    puts "You knocked down #{strike_die2} and #{split_die2} pins (Total: #{total_pins2})"
                    frame.second_roll = total_pins2 > 10 ? 10 : total_pins2
                  end
                end
                # Third roll
                strike_die3 = Bowlero::Dice.roll_strike_die
                split_die3 = Bowlero::Dice.roll_split_die
                if strike_die3 == :strike
                  puts "🎳 STRIKE! Third roll in 10th frame is a strike!"
                  frame.third_roll = 10
                else
                  if split_die3 == :split
                    split_value3 = 6
                    total_pins3 = strike_die3 + split_value3
                    puts "You knocked down #{strike_die3} pins and left a SPLIT! (Split worth 6, Total: #{total_pins3} pins)"
                    frame.third_roll = total_pins3 > 10 ? 10 : total_pins3
                  else
                    split_value3 = split_die3
                    total_pins3 = strike_die3 + split_value3
                    puts "You knocked down #{strike_die3} and #{split_die3} pins (Total: #{total_pins3})"
                    frame.third_roll = total_pins3 > 10 ? 10 : total_pins3
                  end
                end
              else
                # Not a strike by pin count, so check for split or spare
                if split_die == :split
                  split_res = Bowlero::Dice.roll_split_resolution_die
                  if split_res == :spare
                    puts "You converted the split for a SPARE!"
                    frame.result = :spare
                    frame.second_roll = 10 - frame.first_roll
                    # Third roll (bonus)
                    strike_die3 = Bowlero::Dice.roll_strike_die
                    split_die3 = Bowlero::Dice.roll_split_die
                    if strike_die3 == :strike
                      puts "🎳 STRIKE! Third roll in 10th frame is a strike!"
                      frame.third_roll = 10
                    else
                      if split_die3 == :split
                        split_value3 = 6
                        total_pins3 = strike_die3 + split_value3
                        puts "You knocked down #{strike_die3} pins and left a SPLIT! (Split worth 6, Total: #{total_pins3} pins)"
                        frame.third_roll = total_pins3 > 10 ? 10 : total_pins3
                      else
                        split_value3 = split_die3
                        total_pins3 = strike_die3 + split_value3
                        puts "You knocked down #{strike_die3} and #{split_die3} pins (Total: #{total_pins3})"
                        frame.third_roll = total_pins3 > 10 ? 10 : total_pins3
                      end
                    end
                  else
                    puts "Open frame. Some pins left standing."
                    frame.result = :open
                    frame.second_roll = 0
                    frame.third_roll = 0
                  end
                else
                  spare_res = Bowlero::Dice.roll_spare_resolution_die
                  if spare_res == :spare
                    puts "You picked up the spare!"
                    frame.result = :spare
                    frame.second_roll = 10 - frame.first_roll
                    # Third roll (bonus)
                    strike_die3 = Bowlero::Dice.roll_strike_die
                    split_die3 = Bowlero::Dice.roll_split_die
                    if strike_die3 == :strike
                      puts "🎳 STRIKE! Third roll in 10th frame is a strike!"
                      frame.third_roll = 10
                    else
                      if split_die3 == :split
                        split_value3 = 6
                        total_pins3 = strike_die3 + split_value3
                        puts "You knocked down #{strike_die3} pins and left a SPLIT! (Split worth 6, Total: #{total_pins3} pins)"
                        frame.third_roll = total_pins3 > 10 ? 10 : total_pins3
                      else
                        split_value3 = split_die3
                        total_pins3 = strike_die3 + split_value3
                        puts "You knocked down #{strike_die3} and #{split_die3} pins (Total: #{total_pins3})"
                        frame.third_roll = total_pins3 > 10 ? 10 : total_pins3
                      end
                    end
                  else
                    puts "Open frame. Some pins left standing."
                    frame.result = :open
                    frame.second_roll = 0
                    frame.third_roll = 0
                  end
                end
              end
            end
            # For 10th frame, pins = sum of all rolls
            frame.pins = (frame.first_roll || 0) + (frame.second_roll || 0) + (frame.third_roll || 0)
            frames << frame
          end
        end

        # --- Scoring pass ---
        def next_rolls(frames, idx, count)
          rolls = []
          i = idx + 1
          while rolls.size < count && i < frames.size
            f = frames[i]
            rolls << f.first_roll if rolls.size < count
            rolls << f.second_roll if rolls.size < count
            i += 1
          end
          rolls[0, count]
        end

        total_score = 0
        frames.each_with_index do |f, i|
          if i == 9
            # 10th frame: just sum the rolls
            f.score = (f.first_roll || 0) + (f.second_roll || 0) + (f.third_roll || 0)
            total_score += f.score
            f.score = total_score
          elsif f.result == :strike
            bonus_rolls = next_rolls(frames, i, 2)
            f.score = 10 + bonus_rolls.sum
            total_score += f.score
            f.score = total_score
          elsif f.result == :spare
            bonus_rolls = next_rolls(frames, i, 1)
            f.score = 10 + bonus_rolls.sum
            total_score += f.score
            f.score = total_score
          else
            f.score = f.first_roll + f.second_roll
            total_score += f.score
            f.score = total_score
          end
        end

        def print_scorecard(frames)
          # Frame header
          puts '+---' * 10 + '+'
          print '|'
          (1..10).each { |n| print "%2s |" % n }
          puts
          puts '+-+-' * 10 + '+'

          # Rolls row
          print '|'
          frames.each_with_index do |f, i|
            if i == 9
              # 10th frame: show up to 3 rolls
              r1 = f.first_roll == 10 ? 'X' : f.first_roll.to_s
              r2 = f.second_roll == 10 ? 'X' : (f.result == :spare ? '/' : f.second_roll.to_s)
              r3 = f.third_roll == 10 ? 'X' : (f.third_roll.nil? ? ' ' : f.third_roll.to_s)
              print "%s|%s|%s|" % [r1, r2, r3]
            else
              r1 = r2 = ' '
              if f.result == :strike
                r1 = 'X'
                r2 = ' '
              elsif f.result == :spare
                r1 = f.first_roll == 0 ? '-' : f.first_roll.to_s
                r2 = '/'
              elsif f.split
                r1 = f.first_roll == 0 ? '-' : f.first_roll.to_s
                r2 = 'S'
              else
                r1 = f.first_roll == 0 ? '-' : f.first_roll.to_s
                r2 = f.second_roll == 0 ? '-' : f.second_roll.to_s
              end
              print "%s|%s|" % [r1, r2]
            end
          end
          puts
          puts '+---' * 10 + '+'

          # Scores row
          print '|'
          frames.each { |f| print "%3s|" % f.score }
          puts
          puts '+---' * 10 + '+'
        end

        puts "\n--- Game Summary for #{name} ---"
        print_scorecard(frames)
        frames.each do |f|
          case f.result
          when :strike
            puts "Frame #{f.frame_number}: STRIKE! (10 pins) | Running Score: #{f.score}"
          when :spare
            puts "Frame #{f.frame_number}: SPARE! (#{f.pins} pins) | Running Score: #{f.score}"
          else
            puts "Frame #{f.frame_number}: Open frame (#{f.pins} pins) | Running Score: #{f.score}"
          end
        end
        puts "\nFinal Score: #{frames.last.score}"
        puts "\n[Press Enter to return to menu]"
        gets
      end

      main_menu
    end
  end
end 