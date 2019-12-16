require_relative "hash.rb"

class Reaction
    def initialize(line)
        @string = line
        parts = line.split("=>")
        @count,@result = parts[1].scan(/(\d+)\s(\w+)/).flatten
        @count = @count.to_i
        @costs = parts[0].split(",").map do |c|
            cost = c.scan(/(\d+)\s(\w+)/).flatten
            cost[0] = cost[0].to_i
            cost
        end
    end

    def count
        return @count
    end

    def costs
        return @costs
    end

    def result
        return @result
    end

    def to_s
        return @string
    end
end

def buildCosts(needs, reaction, allReactions)
    reaction.costs.each do |c|
        if c[1] != 'ORE'
            needs[c[1]] = (needs[c[1]] || 0) + c[0].to_i
            producer = allReactions.select { |r| r.result == c[1]}[0]
            buildCosts(needs, producer, allReactions)
        end
    end
end

def justProduce(reaction, produced, quantity)
    times = (quantity.to_f / reaction.count).ceil
    oldAmount = produced[reaction.result] || 0
    produced[reaction.result] = oldAmount + (reaction.count * times)
    reaction.costs.each do |cost,result|
        cost = cost * times
        oldAmount = produced[result] || 0
        produced[result] = oldAmount - cost
    end
end

def produceReaction(reaction, reactions, produced, oreHolder, times)
    q = (times.to_f / reaction.count).ceil
    reaction.costs.each do |cost,result|
        cost = cost * q
        if (produced[result] || 0) > cost
            produced[result] = produced[result] - cost
        else
            producer = reactions.select {|r| r.result == result}[0]
            if producer.costs.length == 1 && producer.costs[0][1] == 'ORE'
                # it only costs ore
                while (produced[result] || 0) < cost
                    oreHolder["ORE"] += producer.costs[0][0].to_i * q
                    produced[result] = produced[result] || 0
                    produced[result] += producer.count * q
                end
                produced[result] -= cost
            else
                while (produced[producer.result] || 0) < cost
                    produceReaction(producer, reactions, produced, oreHolder,times)
                end
                produced[producer.result] -= cost
            end
        end
    end
    produced[reaction.result] = produced[reaction.result] || 0
    produced[reaction.result] += reaction.count  * q
end

def produceReactionPart2(reaction, reactions, produced)
    reaction.costs.each do |cost,result|
        if (produced[result] || 0) > cost
            produced[result] = produced[result] - cost
        else
            producer = reactions.select {|r| r.result == result}[0]
            if producer == nil
                # out of ore!
                return
            end
            while (produced[producer.result] || 0) < cost
                produceReactionPart2(producer, reactions, produced)
            end
            produced[producer.result] -= cost
        end
    end
    produced[reaction.result] = produced[reaction.result] || 0
    produced[reaction.result] += reaction.count 
end

def Day14
    input = File.readlines("Day14/Day14.txt").each {|l| l.chomp!}
    reactions = input.map {|l| Reaction.new(l)}
    fuel = reactions.select {|r| r.result == "FUEL"}[0]
    needs = {}
    produced = {"ORE"=>0}
    totalOre = 0
    oreHolder = {"ORE"=>0}
    produceReaction(fuel, reactions, produced,oreHolder,1)
    puts oreHolder
    puts produced
end

def runExperiment(times, reactions)
    fuel = reactions.select {|r| r.result == "FUEL"}[0]
    produced = {"ORE"=>1000000000000}
    oreHolder = {"ORE"=>0}
    justProduce(fuel,produced,times)
    while produced.select{|key,count| count < 0}.length > 0
        produced.select {|key,count| count < 0}.each do |key,count|
            producer = reactions.select{|r| r.result == key}[0]
            if producer == nil
                # not enough ore
                return false
            end
            justProduce(producer,produced,-count)
        end
    end
    # we had enough ore
    return true
end

def Day14Part2
    input = File.readlines("Day14/Day14.txt").each {|l| l.chomp!}
    reactions = input.map {|l| Reaction.new(l)}
    fuel = reactions.select {|r| r.result == "FUEL"}[0]
    found = false
    timesMin = 1
    times = 10000
    timesMax = 100000000
    while found == false
        hadEnough = runExperiment(times,reactions)
        if hadEnough
            timesMin = times
            times += [1, (timesMax - timesMin)/2].max
        else
            timesMax = times
            times -= [1, (timesMax - timesMin)/2].max
            if times == timesMin
                puts times
                found = true
            end
        end
    end
end