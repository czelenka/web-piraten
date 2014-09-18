
class @GameObject
  @ALL = {} # stores a map with the key being the name and the value being the class
  constructor: () ->
    if arguments.length == 2 # (serialized, img)
      serialized = arguments[0]
      @img = arguments[1]
      @name = serialized.name
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

  @registerGameObject = (name, clazz) =>
    @ALL[name] = clazz

  isEqual: (other) =>
    if !other?
      return false
    if !other.name? || other.name != @name
      return false
    if !other.x? || other.x != @x
      return false
    if !other.y? || other.y != @y
      return false
    return true

  serialize: () =>
    {
      name: @name
      x: @x
      y: @y
    }

  update: () =>
    @lifeTime++

class @Ship extends GameObject
  name = "ship"
  GameObject.ALL[name] = Ship

  constructor: () ->
    if arguments.length == 1 # serialized obj
      serialized = arguments[0]
      super serialized, Config.images.ship
      @rotation = serialized.rotation
    else if arguments.length <= 3
      @x = arguments[0]
      @y = arguments[1]
      @isRotating = false
      @rotation = arguments[2] || 0 #optional
      @lastRotation = @rotation
      super name, Config.images.ship, @x, @y
    else throw "invalid ship constructor call"

  turn: (rotation) =>
    @isRotating = true
    @lastRotation = @rotation
    @rotation = rotation


  look: (coord) =>
    Grid.look = new Coordinate(coord.x, coord.y)

  serialize: () =>
    obj = super()
    obj.rotation = @rotation
    return obj

  take: (takenObj) =>
    if takenObj? and takenObj.name in ['treasure', 'buoy']
      Grid.deleteObject takenObj

  put: (obj) =>
   return unless obj?
   if obj.name == "buoy"
    Grid.addObject (new Buoy obj)
   else if obj.name == "treasure"
     Grid.addObject (new Treasure obj)
   else
     console.log obj
     throw 'invalid object to put'

  move: (coord) =>
    return unless coord?
    @x = coord.x
    @y = coord.y
    @isMoving = true


  isEqual: (other) =>
    if !super.isEqual(other) || !other.rotation? || other.rotation == @rotation
      return false
    return true

class @Buoy extends GameObject
  name = "buoy"
  GameObject.ALL[name] = Buoy
  constructor: () ->
    if arguments.length == 1 # serialized obj
      serialized = arguments[0]
      super serialized, Config.images.buoy
    else if arguments.length <= 2
      @x = arguments[0]
      @y = arguments[1]
      super name, Config.images.buoy, @x, @y
    else throw "invalid Buoy constructor call"

class @Wave extends GameObject
  name = "wave"
  GameObject.ALL[name] = Wave
  constructor: () ->
    if arguments.length == 1 # serialized obj
      serialized = arguments[0]
      super serialized, Config.images.wave
    else if arguments.length <= 2
      @x = arguments[0]
      @y = arguments[1]
      super name, Config.images.wave, @x, @y
    else throw "invalid Wave constructor call"

class @Treasure extends GameObject
  name = "treasure"
  GameObject.ALL[name] = Treasure
  constructor: () ->
    if arguments.length == 1 # serialized obj
      serialized = arguments[0]
      super serialized, Config.images.treasure
    else if arguments.length <= 2
      @x = arguments[0]
      @y = arguments[1]
      super name, Config.images.treasure, @x, @y
    else throw "invalid Treasure constructor call"

class @Monster extends GameObject
  name = "monster"
  GameObject.ALL[name] = Monster
  constructor: () ->
    if arguments.length == 1 # serialized obj
      serialized = arguments[0]
      super serialized, Config.images.monster
    else if arguments.length <= 2
      @x = arguments[0]
      @y = arguments[1]
      super name, Config.images.monster, @x, @y
    else throw "invalid Monster constructor call"
