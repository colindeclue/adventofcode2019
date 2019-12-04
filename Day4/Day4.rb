def qualifiesPart2(toCheck)
    toCheck = toCheck.to_s
    decreasing = true
    hasDouble = false
    groupCount = 0
    for i in 1..toCheck.length - 1
        if toCheck[i] == toCheck[i-1]
            groupCount = groupCount + 1
        else
            if groupCount == 1
                hasDouble = true
            end
            groupCount = 0
            if toCheck[i] < toCheck[i-1]
                return false
            end
        end
    end

    return hasDouble || groupCount == 1
end

def qualifies(toCheck)
    toCheck = toCheck.to_s
    decreasing = true
    hasDouble = false
    for i in 1..toCheck.length - 1
        if toCheck[i] == toCheck[i-1]
            hasDouble = true
        elsif toCheck[i] < toCheck[i-1]
            return false
        end
    end

    return hasDouble
end

def Day4()
    puts qualifiesPart2(111144)
    part1Count = 0
    part2Count = 0
    for test in 256310..732737 do
        if qualifies(test)
            part1Count = part1Count + 1
            if qualifiesPart2(test)
                part2Count = part2Count + 1
            end
        end
        
    end

    puts "Part1: #{part1Count}"
    puts "Part2: #{part2Count}"
end