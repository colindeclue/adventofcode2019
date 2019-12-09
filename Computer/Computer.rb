class Computer
    def initialize(code, phase, input)
        @code = code.clone
        @initialCode = code.clone
        @currentInstruction = 0
        @input = phase
        @secondInput = input
        @switched = false
    end

    def getValue(index, mode)
        if mode == 1
            return @code[index]
        else
            return @code[@code[index]]
        end
    end

    def getOutput
        return @output
    end

    def save
        storeIndex = @code[@currentInstruction + 1]
        input = @input
        if !@switched
            @input = @secondInput
            @switched = true
        end
        @code[storeIndex] = input
        @currentInstruction = @currentInstruction + 2
    end

    def output(firstMode)
        parameter = getValue(@currentInstruction + 1, firstMode)
        #puts "Output: #{parameter}"
        @output = parameter
        @currentInstruction = @currentInstruction + 2;
    end

    def jumpIfTrue(firstMode, secondMode)
        parameter = getValue(@currentInstruction + 1, firstMode)
        newPointer = getValue(@currentInstruction + 2, secondMode)
        if parameter != 0
            @currentInstruction = newPointer
        else
            @currentInstruction = @currentInstruction + 3
        end
    end

    def jumpIfFalse(firstMode, secondMode)
        parameter = getValue(@currentInstruction + 1, firstMode)
        newPointer = getValue(@currentInstruction + 2, secondMode)
        if parameter == 0
            @currentInstruction = newPointer
        else
            @currentInstruction = @currentInstruction + 3
        end
    end

    def lessThan(firstMode, secondMode)
        first = getValue(@currentInstruction + 1, firstMode)
        second = getValue(@currentInstruction + 2, secondMode)
        storeIndex =  @code[@currentInstruction + 3]
        toStore = first < second ? 1 : 0
        @code[storeIndex] = toStore
        @currentInstruction = @currentInstruction + 4
    end

    def equals(firstMode, secondMode)
        first = getValue(@currentInstruction + 1, firstMode)
        second = getValue(@currentInstruction + 2, secondMode)
        storeIndex =  @code[@currentInstruction + 3]
        toStore = first == second ? 1 : 0
        @code[storeIndex] = toStore
        @currentInstruction = @currentInstruction + 4
    end

    def add(firstMode, secondMode, thirdMode)
        first = getValue(@currentInstruction + 1, firstMode)
        second = getValue(@currentInstruction + 2, secondMode)
        storeIndex =  @code[@currentInstruction + 3]
        @code[storeIndex] = first + second
        @currentInstruction = @currentInstruction + 4
    end

    def multiply(firstMode, secondMode, thirdMode)
        first = getValue(@currentInstruction + 1, firstMode)
        second = getValue(@currentInstruction + 2, secondMode)
        storeIndex =  @code[@currentInstruction + 3]
        @code[storeIndex] = first * second
        @currentInstruction = @currentInstruction + 4
    end

    def loadAndReset(noun, verb)
        @code = @initialCode.clone
        @code[1] = noun
        @code[2] = verb
        @currentInstruction = 0
    end

    def parseIntruction(instruction)
        instruction = instruction.to_s
        opCode = instruction[-1]
        firstMode = instruction[-3].to_i || 0
        secondMode = instruction[-4].to_i || 0
        thirdMode = instruction[-5].to_i || 0
        if opCode == "1"
            add(firstMode, secondMode, thirdMode)
        elsif opCode == "2"
            multiply(firstMode, secondMode, thirdMode)
        elsif opCode == "3"
            save
        elsif opCode == "4"
            output(firstMode)
        elsif opCode == "5"
            jumpIfTrue(firstMode, secondMode)
        elsif opCode == "6"
            jumpIfFalse(firstMode, secondMode)
        elsif opCode == "7"
            lessThan(firstMode, secondMode)
        elsif opCode == "8"
            equals(firstMode, secondMode)
        end
    end

    def runUntilOutput(input)
        @isDone = false
        @secondInput = input
        if @switched
            @input = input
        end
        currentInstruction = @code[@currentInstruction]
        while currentInstruction != 99
            parseIntruction(currentInstruction)
            if currentInstruction == 4 || currentInstruction.to_s[-1] == "4"
                return
            end
            currentInstruction = @code[@currentInstruction]
        end
        @isDone = true
    end

    def done?
        return @isDone
    end

    def run
        @isDone = false
        currentInstruction = @code[@currentInstruction]
        while currentInstruction != 99
            parseIntruction(currentInstruction)
            currentInstruction = @code[@currentInstruction]
        end
        @isDone = true
    end

    def result
        return @code[0]
    end
end