class Moon
    def initialize(name, x, y, z)
        @x = x
        @y = y
        @z = z
        @xv = 0
        @yv = 0
        @zv = 0
        @name = name
    end
    
    def x
        return @x
    end

    def y
        return @y
    end

    def z
        return @z
    end

    def xv
        return @xv
    end

    def yv
        return @yv
    end

    def zv
        return @zv
    end

    def applyGravity(other)
        if other.x > @x
            @xv = @xv + 1
        elsif other.x < @x
            @xv = @xv - 1
        end
        if other.y > @y
            @yv = @yv + 1
        elsif other.y < @y
            @yv = @yv - 1
        end
        if other.z > @z
            @zv = @zv + 1
        elsif other.z < @z
            @zv = @zv - 1
        end
    end

    def applyVelocity
        @x = @x + @xv
        @y = @y + @yv
        @z = @z + @zv
    end

    def energy
        pot = @x.abs + @y.abs + @z.abs
        kin = @xv.abs + @yv.abs + @zv.abs
        return pot * kin
    end

    def to_s
        return "#{@name}: Pos:<#{@x},#{@y},#{@z}>, Vel:<#{@xv},#{@yv},#{@zv}>, En:<#{energy}>"
    end
end

def applyGravity(moons)
    pairs = moons.combination(2).to_a
    pairs.each { |a,b| a.applyGravity(b); b.applyGravity(a)}
end

def applyVelocity(moons)
    moons.each {|moon| moon.applyVelocity}
end

def Day12
    moons = [Moon.new(0,-1,0,2),Moon.new(1,2,-10,-7),Moon.new(2,4,-8,8),Moon.new(3,3,5,-1)]
    initialX = moons.map{|moon|[moon.x,moon.xv]}
    initialY = moons.map{|moon|[moon.y,moon.yv]}
    initialZ = moons.map{|moon|[moon.z,moon.zv]}
    foundY = false
    for t in 0..99
        applyGravity(moons)
        applyVelocity(moons)
        newX = moons.map{|moon|[moon.x,moon.xv]}
        newY = moons.map{|moon|[moon.y,moon.yv]}
        newZ = moons.map{|moon|[moon.z,moon.zv]}
        if newX == initialX
            puts "X wrap: #{t+1}"
        end
        if newY == initialY
            puts "Y wrap: #{t+1}"
        end
        if newZ == initialZ
            puts "Z wrap: #{t+1}"
        end
    end
    puts moons.inject(0){|sum,m| sum + m.energy}
end