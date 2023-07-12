require 'game'

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

    def update(delta, &block)
        if block_given?
            @update = block
        else
            if @update
                @update.call(delta)
            end

            if @direction
                @x += @speed * delta * Math.cos(@direction)
                @y += @speed * delta * Math.sin(@direction)
            end
        end

        if @x < 0 then @x = 0 end
        if @y < 0 then @y = 0 end

        if @x > Game.width then @x = Game.width end
        if @y > Game.height then @y = Game.height end
    end

    def draw(ctx)
        ctx.fillStyle = 'green'
        ctx.beginPath()
        ctx.arc(@x, @y, RADIUS, 0, 2 * Math::PI)
        ctx.fill()
    end
end