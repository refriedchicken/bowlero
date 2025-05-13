module Bowlero
  class Frame
    attr_accessor :frame_number, :first_roll, :second_roll, :third_roll, :split, :split_converted, :result, :pins, :score

    def initialize(frame_number:,
                   first_roll: nil,
                   second_roll: nil,
                   third_roll: nil,
                   split: false,
                   split_converted: nil,
                   result: nil,
                   pins: 0,
                   score: nil)
      @frame_number = frame_number
      @first_roll = first_roll
      @second_roll = second_roll
      @third_roll = third_roll
      @split = split
      @split_converted = split_converted
      @result = result
      @pins = pins
      @score = score
    end
  end
end 