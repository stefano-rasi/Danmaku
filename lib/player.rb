class Player
    SPEED = 500

    RADIUS = 10

    attr_reader :x
    attr_reader :y

    attr_writer :direction

    def initialize(x, y)
        @x = x
        @y = y

        @speed = SPEED
    end

    def update(delta)
        if @direction
            @x += @speed * delta * Math.cos(@direction)
            @y += @speed * delta * Math.sin(@direction)
        end
    end

    def draw(ctx)
        ctx.fillStyle = 'green'
        ctx.beginPath()
        ctx.arc(@x, @y, RADIUS, 0, 2 * Math::PI)
        ctx.fill()
    end
end