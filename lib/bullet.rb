require 'game'

class Bullet
    SPEED = 300
    RADIUS = 5

    attr_accessor :x, :y

    def initialize(x: nil, y: nil, speed:, target: nil, direction: nil)
        @x = x if x
        @y = y if y

        @speed = speed

        @radius = RADIUS

        @target = target if target
        @direction = direction if direction

        if target && x && y
            @direction = -1 * Math.atan2(
                @y - @target.y,
                @target.x - @x
            )
        end
    end

    def direction
        if not @direction
            @direction = -1 * Math.atan2(
                @y - @target.y,
                @target.x - @x
            )
        end

        @direction
    end

    def update(delta)
        @x += SPEED * @speed * delta * Math.cos(direction)
        @y += SPEED * @speed * delta * Math.sin(direction)
    end

    def dead?
        if @x < 0 || @x > Game.width
            true
        elsif @y < 0 || @y > Game.height
            true
        else
            false
        end
    end

    def draw(ctx)
        ctx.fillStyle = 'white'
        ctx.beginPath()
        ctx.arc(@x, @y, @radius, 0, 2 * Math::PI)
        ctx.fill()
    end
end