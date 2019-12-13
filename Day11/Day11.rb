require_relative "../Computer/Computer.rb"
require 'set'

def build2DArray(grid, finalGrid)
    grid.each do |key, color|
        finalGrid[key[0]] = finalGrid[key[0]] || []
        finalGrid[key[0]][key[1]] = color == 0 ? '.' : '#'
    end
    return finalGrid
end

def Day11
    input = "3,8,1005,8,327,1106,0,11,0,0,0,104,1,104,0,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,1001,8,0,28,1006,0,42,2,1104,11,10,1006,0,61,2,1005,19,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,1,10,4,10,102,1,8,65,1006,0,4,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,1,8,10,4,10,1002,8,1,89,1,1108,10,10,1,1103,11,10,1,109,18,10,1006,0,82,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,102,1,8,126,2,109,7,10,1,104,3,10,1006,0,64,2,1109,20,10,3,8,1002,8,-1,10,101,1,10,10,4,10,108,1,8,10,4,10,101,0,8,163,3,8,102,-1,8,10,1001,10,1,10,4,10,108,1,8,10,4,10,1002,8,1,185,2,1109,12,10,2,103,16,10,1,107,11,10,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,1001,8,0,219,1,1005,19,10,3,8,102,-1,8,10,1001,10,1,10,4,10,108,1,8,10,4,10,102,1,8,245,2,1002,8,10,1,2,9,10,1006,0,27,1006,0,37,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,0,8,10,4,10,102,1,8,281,1006,0,21,3,8,102,-1,8,10,101,1,10,10,4,10,108,0,8,10,4,10,1001,8,0,306,101,1,9,9,1007,9,1075,10,1005,10,15,99,109,649,104,0,104,1,21102,1,847069852568,1,21101,344,0,0,1105,1,448,21101,0,386979963688,1,21101,355,0,0,1105,1,448,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,21102,46346031251,1,1,21101,0,402,0,1105,1,448,21102,1,29195594775,1,21101,0,413,0,1105,1,448,3,10,104,0,104,0,3,10,104,0,104,0,21101,0,868498428772,1,21101,0,436,0,1106,0,448,21102,718170641172,1,1,21102,1,447,0,1105,1,448,99,109,2,21202,-1,1,1,21102,40,1,2,21102,1,479,3,21102,1,469,0,1105,1,512,109,-2,2105,1,0,0,1,0,0,1,109,2,3,10,204,-1,1001,474,475,490,4,0,1001,474,1,474,108,4,474,10,1006,10,506,1101,0,0,474,109,-2,2106,0,0,0,109,4,2102,1,-1,511,1207,-3,0,10,1006,10,529,21101,0,0,-3,22101,0,-3,1,22101,0,-2,2,21101,0,1,3,21101,548,0,0,1106,0,553,109,-4,2106,0,0,109,5,1207,-3,1,10,1006,10,576,2207,-4,-2,10,1006,10,576,21202,-4,1,-4,1106,0,644,22101,0,-4,1,21201,-3,-1,2,21202,-2,2,3,21102,1,595,0,1105,1,553,21201,1,0,-4,21101,0,1,-1,2207,-4,-2,10,1006,10,614,21102,1,0,-1,22202,-2,-1,-2,2107,0,-3,10,1006,10,636,22102,1,-1,1,21102,1,636,0,106,0,511,21202,-2,-1,-2,22201,-4,-2,-4,109,-5,2105,1,0".split(',').map do |number| Integer(number) end
    robotComputer = Computer.new(input,1,1)
    robotPosition = [25,25]
    finalGrid = []
    for y in 0..65 do
        finalGrid[y] = []
        for x in 0..50 do
            finalGrid[y][x] = '.'
        end
    end
    finalGrid[25][25] = '#'
    currentDirection = 0 #up,right,down,left
    grid = {}
    paintedPositions = Set.new
    currentColor = 1
    while !robotComputer.done? do
        robotComputer.runUntilOutput(currentColor)
        grid[robotPosition] = robotComputer.getOutput
        finalGrid[robotPosition[1]][robotPosition[0]] = robotComputer.getOutput == 1 ? '#' : '.'
        paintedPositions.add(robotPosition)
        robotComputer.runUntilOutput(currentColor)
        turnDirection = robotComputer.getOutput
        currentDirection = (currentDirection + (turnDirection == 0 ? -1 : 1)) % 4
        if currentDirection == 0
            robotPosition = [robotPosition[0], robotPosition[1] + 1]
        elsif currentDirection == 1
            robotPosition = [robotPosition[0] + 1, robotPosition[1]]
        elsif currentDirection == 2
            robotPosition = [robotPosition[0], robotPosition[1] -1]
        elsif currentDirection == 3
            robotPosition = [robotPosition[0] - 1, robotPosition[1]]
        end
        currentColor = grid[robotPosition] || 0
    end
    puts "Part1 #{paintedPositions.length}"
    #finalGrid = build2DArray(grid,finalGrid)
    puts finalGrid.reverse.map { |x| x.join(' ') }
end