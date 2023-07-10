require 'game'
require 'sequence'

class Enemy
    SPEED = 300
    RADIUS = 10

    attr_reader :x
    attr_reader :y

    attr_writer :sequence

    def initialize(x, y, &block)
        @x = x
        @y = y

        @speed = SPEED
        @radius = RADIUS

        if block_given?
            sequence = Sequence.new(self)

            sequence.define :width, Game.width
            sequence.define :height, Game.height
            sequence.define :player, Game.player

            sequence.instance_eval(&block)

            sequence.reset()

            @sequence = sequence
        end
    end

    def shoot(bullet)
        bullet.x = @x if not bullet.x
        bullet.y = @y if not bullet.y

        Game.objects << bullet
    end

    def move(x, y, time=nil)
        @direction = -1 * Math.atan2(@y - y, x - @x)

        if time
            distance = Math.sqrt((@x - x) ** 2 + (@y - y) ** 2)

            @speed = distance.fdiv(time)
        end
    end

    def update(delta)
        if @sequence
            @sequence.update(delta)
        end

        if @direction
            @x += @speed * delta * Math.cos(@direction)
            @y += @speed * delta * Math.sin(@direction)
        end
    end

    def draw(ctx)
        ctx.fillStyle = 'red'
        ctx.beginPath()
        ctx.arc(@x, @y, RADIUS, 0, 2 * Math::PI)
        ctx.fill()
    end
end