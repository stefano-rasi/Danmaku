require 'time'
require 'native'
require 'sequence'

class Game
    WIDTH = 400
    HEIGHT = 600

    BACKGROUND = 'black'

    class << self
        attr_reader :width
        attr_reader :height
        attr_reader :player
        attr_reader :sequence

        attr_accessor :objects

        def init()
            @width = WIDTH
            @height = HEIGHT

            @objects = []

            @window = $$.window
            @document = $$.document

            @canvas = @document.querySelector('canvas')

            @canvas.width = @width
            @canvas.height = @height

            @ctx = @canvas.getContext('2d')

            @sequence = Sequence.new(self)
        end

        def enemy(enemy, &block)
            @objects << enemy

            if block_given?
                sequence = Sequence.new(enemy)

                sequence.define :width, Game.width
                sequence.define :height, Game.height
                sequence.define :player, Game.player

                sequence.instance_eval(&block)
    
                sequence.reset()

                enemy.sequence = sequence
            end
        end

        def player=(player)
            @player = player

            @objects << player
        end

        def start()
            @last_time = nil

            @sequence.reset()

            @window.requestAnimationFrame(proc { game_loop })
        end

        def game_loop()
            time = Time.now()

            if @last_time
                delta = time - @last_time
            else
                delta = 0
            end

            @last_time = time

            update(delta)

            draw()

            @window.requestAnimationFrame(proc { game_loop })
        end

        def update(delta)
            @sequence.update(delta)

            @objects.delete_if do |object|
                object.update(delta)

                if object.respond_to? :dead?
                    object.dead?
                else
                    false
                end
            end
        end

        def draw()
            @ctx.fillStyle = BACKGROUND
            @ctx.fillRect(0, 0, @width, @height)

            @objects.each do |object|
                object.draw(@ctx)
            end
        end
    end
end