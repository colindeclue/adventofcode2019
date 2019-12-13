class Asteroid
    def initialize(x, y)
        @x = x
        @y = y
        @distances = {}
        @allMatches = []
        @foundMatches = false
    end

    def x
        return @x
    end

    def y
        return @y
    end

    def exactlyBetween(goal, middle)
        thisDistance = distance(goal) - (distance(middle) + middle.distance(goal))
        return thisDistance <= 0.00001 && thisDistance >= -0.00001
    end

    def detects(goal, all)
        return all.none? do |key,a|
            a != goal && a != self && exactlyBetween(goal,a)
        end
    end

    def allMatches(all)
        if @foundMatches
            return @allMatches
        end
        @allMatches = all.select do |key, a|
            a != self && detects(a,all)
        end
        @foundMatches = true
        return @allMatches
    end

    def key
        return "#{@x},#{@y}"
    end

    def distances
        return @distances
    end

    def distance(other)
        if @distances[other] != nil || other.distances[self] != nil
            return @distances[other] || other.distances[self]
        end
        thisDistance = Math.sqrt(((other.x - @x) ** 2) + ((other.y - @y) ** 2))
        @distances[other] = thisDistance
        other.distances[self] = thisDistance
        return thisDistance
    end

    def getPrint(all)
        allMatches(all).length.to_s
    end

    def angle(other)
        return Math.atan2(other.x - @x, other.y - @y)
    end

    def to_s
        return key
    end
end

def print(all,width, height)
    finalGrid = []
    for y in 0..height-1
        finalGrid[y] = []
        for x in 0..width-1
            asteroid = all["#{x},#{y}"]
            key = "."
            if asteroid != nil
                key = asteroid.getPrint(all)
            end
            finalGrid[y][x] = key
        end
    end
    width = finalGrid.flatten.max.to_s.size+2
    puts finalGrid.map { |a| a.map { |i| i.to_s.rjust(width) }.join }
end

def Day10
    input = File.readlines("Day10/Day10.txt").each {|l| l.chomp!}
    possible = {}
    asteroids = input.each_with_index do |line,y|
        line.each_char.each_with_index do |char,x|
            if char == '#'
                possible["#{x},#{y}"] = Asteroid.new(x,y)
            end
        end
    end
    print(possible,input[0].length,input.length)
    #puts possible["11,13"].allMatches(possible).length
    maxCount = 0
    maxIndex = ""
    index = 0
    possible.each do |key,a|
        puts "#{index}/#{possible.length}"
        count = a.allMatches(possible).length
        if count > maxCount
            maxCount = count
            maxIndex = key
        end
        index = index + 1
    end
    puts possible[maxIndex].getPrint(possible)
    puts "#{maxCount} #{maxIndex}"
end


def Day10Part2
    input = File.readlines("Day10/Day10.txt").each {|l| l.chomp!}
    asteroids = {}
    input.each_with_index do |line,y|
        line.each_char.each_with_index do |char,x|
            if char == '#'
                asteroids["#{x},#{y}"] = Asteroid.new(x,y)
            end
        end
    end
    station = asteroids.delete("26,29")
    sorted = asteroids.map { |key,asteroid| asteroid }.to_a.sort_by { |a| [-station.angle(a), station.distance(a)]}.group_by { |a| station.angle(a)}
    sorted = sorted.map{ |angle,list| list}
    sorted = Array.new(sorted.map(&:length).max){|i| sorted.map{|e| e[i]}}.flatten.select{|a| a != nil}
    puts sorted[199]
end