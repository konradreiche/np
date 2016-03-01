class Constraint 

  attr_accessor :starting, :ending

  def initialize(starting, ending)
    now = Time.now
    self.starting = Time.new(now.year, now.month, now.day, starting)
    self.ending   = Time.new(now.year, now.month, now.day, ending)
  end

  def cover?(time)
    (starting..ending).cover?(time)
  end

end
