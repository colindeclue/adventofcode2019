def mark(dictionary, x, y, steps, index) 
    current = dictionary["#{x},#{y}"] 
    if current == nil
        current = {index => steps}
    end
    if current[index] == nil
        current[index] = steps
    end
    dictionary["#{x},#{y}"] = current
end

def evaluateLine(dictionary, line, index)
    x = 0
    y = 0
    steps = 1
    instructions = line.split(',')
    instructions.each do |instruction|
        direction = instruction[0]
        count = Integer(instruction[1..-1])
        case direction
        when 'R'
            for x in x+1..x+count
                mark(dictionary, x, y, steps, index)
                steps = steps + 1
            end
        when 'L'
            endX = x-count 
            for x in (x-1).downto(endX)
                mark(dictionary, x, y, steps, index)
                steps = steps + 1
            end
            x = endX
        when 'U'
            for y in y+1..y+count
                mark(dictionary, x, y, steps, index)
                steps = steps + 1
            end
        when 'D'
            endY = y - count
            for y in (y-1).downto(endY)
                mark(dictionary, x, y, steps, index)
                steps = steps + 1
            end
            y = endY
        end
    end
end

def Day3(part1)
    input = File.readlines("Day3/Day3.txt").each {|l| l.chomp!}
    dictionary = {}
    index = 1
    input.each do |line|
        evaluateLine(dictionary, line, index)
        index = index * 10
    end
    distances = []
    dictionary.each do |key, value|
        if value[1] != nil && value[10] != nil && key != "0,0"
            if part1
                values = key.split(',').map do |value| 
                    Integer(value).abs() 
                end
                distances << values.reduce(:+)
            else
                distances << value[1] + value[10]
            end
        end
    end
    
    puts distances.min
end