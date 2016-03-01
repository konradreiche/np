require './parser'
require './room'
require './timeslot'
require './constraint'
require 'date'

class Scheduler

  attr_accessor :meetings, :rooms

  def initialize(meetings, rooms)
    self.meetings = meetings.shuffle.sort
    self.rooms = rooms
  end

  def schedule
    meetings.each_with_index do |meeting, i|
      rooms[i % 2].allocate(meeting)
    end

    puts rooms[0]
    puts rooms[1]
  end

end


c1 = Constraint.new(0, 9)
c2 = Constraint.new(12, 13)
c3 = Constraint.new(17, 0)

r1 = Room.new(name: 'Room 1', constraints: [c1, c2, c3])
r2 = Room.new(name: 'Room 2', constraints: [c1, c2, c3])

Scheduler.new(Parser.parse('test.txt'), [r1, r2]).schedule
