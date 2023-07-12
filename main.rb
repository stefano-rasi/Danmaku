require 'opal'
require 'native'
require 'opal-parser'

require 'game'
require 'enemy'
require 'bullet'
require 'player'

window = $$.window
document = $$.document

sequence = document.querySelector('#sequence').value

keys = Set.new()

document.addEventListener('keyup') do |event|
    keys.delete(Native(event).key)
end

document.addEventListener('keydown') do |event|
    keys.add(Native(event).key)
end

Game.init()

width = Game.width
height = Game.height

player = Player.new(width * 0.5, height * 0.8)

player.update do
    x = 0
    y = 0

    keys.each do |key|
        if key == 'ArrowUp' then y = -1 end
        if key == 'ArrowDown' then y = 1 end
        if key == 'ArrowLeft' then x = -1 end
        if key == 'ArrowRight' then x = 1 end
    end

    if x == 0 && y == 0
        player.direction = nil
    else
        player.direction = Math.atan2(y, x)
    end
end

Game.player = player

window.fetch(sequence).then do |response|
    Native(response).text().then do |text|
        sequence = Game.sequence

        sequence.define :width, Game.width
        sequence.define :height, Game.height
        sequence.define :player, Game.player

        sequence.instance_eval(text)

        sequence.reset()
    end
end

Game.start()