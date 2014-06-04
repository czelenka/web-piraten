#= require ./utilities
#= require ./config
#= require ./socketHandler
class @GameObject
  @ALL = {} # stores a map with the key being the name and the value being the class
  constructor: () ->
    if arguments.length == 2 # (serialized, img)
      serialized = arguments[0]
      @img = arguments[1]
      @x = serialized.x
      @y = serialized.y
    else if arguments.length == 4 # (name, img, x, y)
      @name = arguments[0]
      @img = arguments[1]
      @x = arguments[2]
      @y = arguments[3]
    else "invalid game object constructor call"
    @image = new Image()
    @image.src = @img
    @lifeTime = 0


  serialize: () =>
    {
      name: @name
      x: @x
      y: @y
    }

  update: () =>
    @lifeTime++

class @Ship extends GameObject
  name = "PirateShip"
  GameObject.ALL[name] = Ship

  getNextCoordinate = (x, y, rotation) ->
    switch rotation
      when 0 then x++ # east
      when 1 then y++ # south
      when 2 then x-- # west
      when 3 then y-- # north
    return { x: x, y: y }

  constructor: () ->
    if arguments.length == 1 # serialized obj
      serialized = arguments[0]
      super serialized, Config.shipImage
      @rotation = serialized.rotation
    else if arguments.length <= 3
      @x = arguments[0]
      @y = arguments[1]
      @rotation = arguments[2] || 0 #optional
      super name, Config.shipImage, @x, @y
    else throw "invalid ship constructor call"

  turn: (rotation) =>
    @rotation = rotation

  look: (coord) =>
    coord2 = new Coordinate()
    coord2.x = coord[0]
    coord2.y = coord[1]
    Grid.look = coord2

  lookAway: () =>
    Grid.look = null

  serialize: () =>
    obj = super()
    obj.rotation = @rotation
    return obj

  take: () =>
    obj = Grid.isSomethingOnPosition @x, @y
    if obj.name == "Treasure"
      Grid.deleteObject obj
      console.log "Gold eingesammelt"
    else
      console.log "hier ist nichts zu holen"

  put: () =>
   if Grid.isSomethingOnPosition(@x, @y) != false
    Utils.logError "hier ist kein Platz mehr für eine Boje"
   else
    Grid.addObject (new Buoy @x, @y)

  move: () =>
    console.log(@rotation)
    coords = getNextCoordinate @x, @y, @rotation
    @x = coords.x
    @y = coords.y


class @Buoy extends GameObject
  name = "Buoy"
  GameObject.ALL[name] = Buoy
  constructor: () ->
    if arguments.length == 1 # serialized obj
      serialized = arguments[0]
      super serialized, Config.buoyImage
      @rotation = serialized.rotation
    else if arguments.length <= 2
      @x = arguments[0]
      @y = arguments[1]
      super name, Config.buoyImage, @x, @y
    else throw "invalid Buoy constructor call"

class @Wave extends GameObject
  name = "Wave"
  GameObject.ALL[name] = Wave
  constructor: () ->
    if arguments.length == 1 # serialized obj
      serialized = arguments[0]
      super serialized, Config.waveImage
      @rotation = serialized.rotation
    else if arguments.length <= 2
      @x = arguments[0]
      @y = arguments[1]
      super name, Config.waveImage, @x, @y
    else throw "invalid Wave constructor call"

class @Treasure extends GameObject
  name = "Treasure"
  GameObject.ALL[name] = Treasure
  constructor: () ->
    if arguments.length == 1 # serialized obj
      serialized = arguments[0]
      super serialized, Config.treasureImage
      @rotation = serialized.rotation
    else if arguments.length <= 2
      @x = arguments[0]
      @y = arguments[1]
      super name, Config.treasureImage, @x, @y
    else throw "invalid Treasure constructor call"

class @Monster extends GameObject
  name = "Monster"
  GameObject.ALL[name] = Monster
  constructor: () ->
    if arguments.length == 1 # serialized obj
      serialized = arguments[0]
      super serialized, Config.monsterImage
      @rotation = serialized.rotation
    else if arguments.length <= 2
      @x = arguments[0]
      @y = arguments[1]
      super name, Config.monsterImage, @x, @y
    else throw "invalid Monster constructor call"
