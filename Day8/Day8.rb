require 'enumerator'

class Image
    def initialize(width, height, pixels)
        @grid = []
        @flat = []
        @width = width
        @height = height
        index = 0
        for y in 0..height-1
            @grid[y] = []
            for x in 0..width-1
                @flat.push pixels[index]
                @grid[y][x] = pixels[index]
                index = index + 1
            end
        end
    end

    def print
        puts @grid.map { |x| x.join(' ') }
    end

    def count(digit)
        @flat.count(digit)
    end

    def grid
        return @grid
    end
end

def getPixel(x, y, layers)
    current = 2
    layers.each do |l|
        current = l.grid[y][x]
        break if current != 2
    end
    return current == 0 ? '*' : 'X'
end

def Day8
    width = 25
    height = 6
    input = File.readlines("Day8/Day8.txt").each {|l| l.chomp!}[0].each_char.map(&:to_i)
    layers = []
    input.each_slice(width * height) do |pixels|
        layers.push Image.new(width, height, pixels)
    end

    max = layers.min_by { |l| l.count(0)}
    part1 = max.count(1) * max.count(2)
    puts "Part1 #{part1}"

    finalGrid = []
    for y in 0..height-1
        finalGrid[y] = []
        for x in 0..width-1
            finalGrid[y][x] = getPixel(x,y,layers)
        end
    end
    puts finalGrid[0][0]
    puts finalGrid.map { |x| x.join(' ') }
end