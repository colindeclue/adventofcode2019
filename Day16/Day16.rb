def makeArray(pattern, index, length)
    output = []
    for x in 0..index -1
        output.push(0)
    end
    patternIndex = 1
    while output.length < length
        for x in 0..index
            output.push(pattern[patternIndex % pattern.length])
            if output.length == length
                return output
            end
        end
        patternIndex += 1
    end

    return output
end

def phase(input)
    pattern = [0,1,0,-1]
    output = []
    input.each_with_index do |digit, index|
        newOutput = input.zip(makeArray(pattern,index,input.length)).map{|a,b|a*b}.inject(:+)
        output.push(newOutput.abs % 10)
    end
    return output
end

def phaseWithOffset(previous, current)
    sum = 0
    (current.length - 1).downto(0).each do |d|
        sum += previous[d]
        current[d] = sum % 10
    end
    return current
end

def Day16
    input = "59731816011884092945351508129673371014862103878684944826017645844741545300230138932831133873839512146713127268759974246245502075014905070039532876129205215417851534077861438833829150700128859789264910166202535524896960863759734991379392200570075995540154404564759515739872348617947354357737896622983395480822393561314056840468397927687908512181180566958267371679145705350771757054349846320639601111983284494477902984330803048219450650034662420834263425046219982608792077128250835515865313986075722145069152768623913680721193045475863879571787112159970381407518157406924221437152946039000886837781446203456224983154446561285113664381711600293030463013"
    part1Input = input.split("").map(&:to_i)
    for x in 0..99
        part1Input = phase(part1Input)
    end
    puts "Phase 1 #{part1Input[0,8].join.to_s}"
    part2input = (input * 10000).split("").map(&:to_i)
    offset = part2input[0,7].join.to_i
    restWidth = part2input.length - offset
    previous = part2input[-restWidth..-1]
    current = previous
    for x in 0..99
        previous = phaseWithOffset(previous, current)
    end
    puts "Phase 2 #{previous[0,8].join}"
end