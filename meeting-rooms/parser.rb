require './meeting'

class Parser

  def self.parse(filename)
    File.readlines(filename).map do |line|
      params = line.split(/ (\d+)/)
      Meeting.new(params[0], params[1])
    end
  end

end
