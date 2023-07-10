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

Game.init()

width = Game.width
height = Game.height

Game.player = Player.new(width * 0.5, height * 0.8)

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