require 'ostruct'

class Room < OpenStruct

  def initialize(args)
    super(args)
    self.schedule = Hash.new
    now = Time.now
    self.current_time = Time.new(now.year, now.month, now.day, starting)
  end

  def next_available_time
    constraints.each do |constraint|
      if constraint.cover?(self.current_time)
        self.current_time = constraint.ending
      end
    end
    self.current_time
  end

  ##
  # Uses a greedy approach. Sort meetings by duration and allocate as many as
  # possible before running into a constraint.
  #
  def allocate(meeting)
    schedule[next_available_time] = meeting
    self.current_time += meeting.duration
    
    timeslot = (self.current_time - meeting.duration..self.current_time)
    if timeslot.cover?(constraints.last.starting)
      puts "#{meeting} could not be allocated anymore"
      schedule[next_available_time] = nil
      self.current_time -= meeting.duration
    end
  end

  def to_s
    timetable = ["#{self.name}:"]
    self.schedule.each do |time, meeting|
      timetable << "#{time.strftime("%I:%M%p")} #{meeting}"
    end
    timetable.join("\n")
  end

end
