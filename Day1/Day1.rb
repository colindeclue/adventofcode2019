
def calculateModule(input) 
    return (input / 3) - 2
end

def calculateFull(input)
    result = calculateModule(input)
    if result <= 0 then
        return 0;
    end
    return result + calculateFull(result)
end

def Day1()
    input = File.readlines("Day1/day1.txt").each {|l| l.chomp!}
    input = input.map do |number|
        Integer(number)
    end
    part1 = input.map do |weight|
        calculateModule(weight)
    end
    part2 = input.map do |weight|
        calculateFull(weight)
    end

    puts "Part1: #{part1.reduce(:+)}"
    puts "Part2: #{part2.reduce(:+)}"
end
