class Meeting
  include Comparable

  attr_accessor :title, :duration

  def initialize(title, duration)
    self.title = title
    self.duration = duration.to_i * 60
  end

  def <=>(other)
    duration <=> other.duration
  end

  def to_s
    "#{title} #{duration / 60}min"
  end

end
