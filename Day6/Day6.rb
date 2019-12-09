class Orbit
    def initialize(name, inner)
        @name = name
        @inner = inner
    end

    def setInner(inner)
        @inner = inner
    end

    def inner
        return @inner
    end

    def orbitCount
        if @inner == nil
            return 0
        end
        return 1 + @inner.orbitCount
    end
end

def Day6
    input = File.readlines("Day6/day6.txt").each {|l| l.chomp!}
    orbits = {}
    input.each do |orbitDescription|
        parts = orbitDescription.split(")")
        orbitee = orbits[parts[0]] || Orbit.new(parts[0], nil)
        if orbits[parts[1]] != nil
            orbits[parts[1]].setInner(orbitee)
        else
            orbiter = orbits[parts[1]] || Orbit.new(parts[1], orbitee)
            orbits[parts[1]] = orbiter
        end
        orbits[parts[0]] = orbitee
    end

    counted = []
    count = 0
    count = orbits.map do |key, value|
        value.orbitCount
    end
    #orbits.each do |key, value|
     #   unless counted.include? value
      #      counted << value
       #     count = count + value.orbitCount
       # end
    #end

    puts "Part1 #{count.inject(:+)}"
    you = orbits["YOU"]
    san = orbits ["SAN"]
    puts you.orbitCount
    puts san.orbitCount
    found = false
    start = 0
    currentGoal = san.inner
    currentOrbit = you.inner
    while !found
        currentRun = 0
        while currentOrbit != nil
            if currentOrbit == currentGoal
                puts "Part2 #{start + currentRun}"
                return
            else
                currentOrbit = currentOrbit.inner
                currentRun = currentRun + 1
            end
        end
        currentGoal = currentGoal.inner
        currentOrbit = you.inner
        start = start + 1
    end
end