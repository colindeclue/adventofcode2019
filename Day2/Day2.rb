require_relative "../Computer/Computer.rb"

def Day2()
    input = "1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,10,19,1,19,6,23,2,23,13,27,1,27,5,31,2,31,10,35,1,9,35,39,1,39,9,43,2,9,43,47,1,5,47,51,2,13,51,55,1,55,9,59,2,6,59,63,1,63,5,67,1,10,67,71,1,71,10,75,2,75,13,79,2,79,13,83,1,5,83,87,1,87,6,91,2,91,13,95,1,5,95,99,1,99,2,103,1,103,6,0,99,2,14,0,0".split(',').map do |number| Integer(number) end
    comp = Computer.new(input)
    #comp.run
    #puts comp.result()
    comp.loadAndReset(12, 2)
    comp.run
    part1 = comp.result()
    puts "Part 1: #{part1}"
    noun = 0
    verb = 0
    for noun in 0..99 do
        for verb in 0..99 do
            #puts "Current: #{noun},#{verb}"
            comp.loadAndReset(noun, verb)
            comp.run
            potential = comp.result
            if potential == 19690720
                puts "Part 2: #{100 * noun + verb}"
                return
            end
        end
    end
end

def evaluate(noun, verb) 
    input = "1,#{noun},#{verb},3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,10,19,1,19,6,23,2,23,13,27,1,27,5,31,2,31,10,35,1,9,35,39,1,39,9,43,2,9,43,47,1,5,47,51,2,13,51,55,1,55,9,59,2,6,59,63,1,63,5,67,1,10,67,71,1,71,10,75,2,75,13,79,2,79,13,83,1,5,83,87,1,87,6,91,2,91,13,95,1,5,95,99,1,99,2,103,1,103,6,0,99,2,14,0,0".split(',').map do |number| Integer(number) end
        currentIndex = 0
        currentInstruction = input[currentIndex]
        while currentInstruction != 99
            storeIndex = input[currentIndex + 3]
            first = input[input[currentIndex + 1]]
            second = input[input[currentIndex + 2]]
            if currentInstruction == 1
                input[storeIndex] = first + second
            else
                input[storeIndex] = first * second
            end
            currentIndex = currentIndex + 4
            currentInstruction = input[currentIndex]
        end
    
        return input[0]
end