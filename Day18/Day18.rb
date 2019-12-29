require_relative "../PQueue/PQueue.rb"

class Point
    def initialize(x, y)
        @x = x
        @y = y
        @distances = {}
    end

    def x
        @x
    end

    def y
        @y
    end

    def neighbors
        return [Point.new(@x-1,@y),Point.new(@x+1,@y),Point.new(@x,@y-1),Point.new(@x,@y+1)]
    end

    def distance(other)
        if @distances[other] != nil || other.distances[self] != nil
            return @distances[other] || other.distances[self]
        end
        thisDistance = (other.y - @y).abs + (other.y - @y).abs
        @distances[other] = thisDistance
        other.distances[self] = thisDistance
        return thisDistance
    end
end

# a each run, next possible moves are paths to a key that we can open all doors to, sort by shortest path
# priority queue, possible?
class PathCalculator
    def initialize(grid)
        @grid = grid
        @paths = {}
    end

    def calculatePathToKey(point, keyPoint)
        # check in @paths, otherwise calculate (dijkstra's)
        pathKey = "#{point.x},#{point.y},#{keyPoint[0]},#{keyPoint[1]}"
        if @paths[pathKey] != nil
            return @paths[pathKey]
        end
        goal = keyPoint
        goalPoint = Point.new(goal[0],goal[1])
        # calculate
        previous = {}
        distances = {}
        queue = Queue.new
        distances[[point.x,point.y]] = 0
        previous[[point.x,point.y]] = point
        queue << point
        continue = true
        while continue && queue.size > 0 do
            current = queue.pop
            if current.x == goal[0] && current.y == goal[1]
                continue = false
            else
                neighbors = current.neighbors
                neighbors.each do |n|
                    if @grid[[n.x,n.y]] == '#'
                        next
                    end
                    currentLength = distances[[current.x,current.y]] || 0
                    newLength = currentLength + 1
                    previousLength = distances[[n.x,n.y]] || 1<< 64
                    if newLength < previousLength
                        distances[[n.x,n.y]] = newLength
                        queue << n
                        previous[[n.x,n.y]] = current
                    end
                end
            end
        end

        path = []
        current = goalPoint
        if current != nil
            while current != nil && (current.x != point.x || current.y != point.y)
                path.unshift({"value" => @grid[[current.x,current.y]], "key" => current})
                current = previous[[current.x,current.y]]
            end
        end

        @paths[pathKey] = path
        return path
    end
end

def getVisitedKey(keys, positions)
    return keys.chars.sort.join + positions.map{|p|"#{p.x},#{p.y}"}.join(",")
end

def getNeededKeys(path)
    neededKeys = []
    path.each do |step|
        if /[[:upper:]]/.match(step)
            neededKeys.push(step.downcase)
        end
    end
    return neededKeys
end

def part1(grid, keys, keyLocations, currentPosition, totalPathLength, pathFinder, minHolder, keysHolder, pathLengthHolder)
    neededKeys = keyLocations.select{|key,value|!keys.include?(value)}
    if neededKeys.length == 0
        if totalPathLength < minHolder["min"]
            minHolder["min"] = totalPathLength
        end
        return [totalPathLength]
    end
    visitedKey = getVisitedKey(keys,[currentPosition])
    if pathLengthHolder[visitedKey] != nil
        #puts totalPathLength + pathLengthHolder[visitedKey]
        return [totalPathLength + pathLengthHolder[visitedKey]]
    end
    possibleSteps = []
    possiblePaths = neededKeys.map{|key,value|pathFinder.calculatePathToKey(currentPosition,key)}.sort_by{|p|p.length}
    possiblePaths.each do |path|
        pathString = path.map{|step|step["value"]}
        if keysHolder[pathString] == nil
            keysHolder[pathString] = getNeededKeys(pathString)
        end
        if !keysHolder[pathString].all?{|key|keys.include?key}
            next
        end
        newKeys = keys.dup
        newKeys += path.last["value"]
        if totalPathLength + path.length > minHolder["min"]
            next
        end
        possibleSteps += part1(grid, newKeys, keyLocations, path.last["key"], totalPathLength + path.length, pathFinder, minHolder, keysHolder, pathLengthHolder).flatten
        #visitedKey = getVisitedKey(newKeys, path.last["key"], totalPathLength + path.length)
        #minLength = possibleSteps.min
        #if minLength != nil && minLength < (pathLengthHolder[visitedKey] || 1 << 64)
        #    pathLengthHolder[visitedKey] = minLength
        #end
    end
    if possibleSteps.length > 0
        pathLengthHolder[visitedKey] = pathLengthHolder[visitedKey] || 0
        pathLengthHolder[visitedKey] = possibleSteps.min - totalPathLength
    end
    
    return possibleSteps
end

def printGrid(grid)
    min_x = grid.keys.min_by{|p|p[0]}[0]
    max_x = grid.keys.max_by{|p|p[0]}[0]
    min_y = grid.keys.min_by{|p|p[1]}[1]
    max_y = grid.keys.max_by{|p|p[1]}[1]
    for y in min_y..max_y
        print "\n"
        for x in min_x..max_x
            print grid[[x,y]] || '?'
        end
    end
    print "\n"
end

def Day18
    lines = File.readlines("Day18/Day18.txt").each {|l| l.chomp!}
    grid = {}
    x = 0
    y = 0
    lines.each do |line|
        x = 0
        line.each_char do |c|
            grid[[x,y]] = c
            x += 1
        end
        y += 1
    end
    printGrid(grid)
    currentLocations = grid.select{|key,value| value == '@'}.keys
    currentPositions = currentLocations.map{|currentLocation|Point.new(currentLocation[0],currentLocation[1])}
    pathFinder = PathCalculator.new(grid)
    keyLocations = grid.select{|key,value|/[[:lower:]]/.match(value)}
    minHolder = {"min" => 1 << 64}
    t1 = Time.now
    puts part1(grid,"", keyLocations, currentPositions[0], 0, pathFinder, minHolder,{},{}).min
    puts Time.now - t1
end