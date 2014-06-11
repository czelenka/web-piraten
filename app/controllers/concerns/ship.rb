# -*- encoding : utf-8 -*-
class Ship
  attr_accessor :x, :y, :rotation

  def initialize(x, y, rotation, grid)
    @x = x
    @y = y
    @rotation = rotation
    @grid = grid
  end

  def turn!(packet, direction) # event: ship.left
    case direction
      when :left
        @rotation = (@rotation - 1) % 4
      when :right
        @rotation = (@rotation + 1) % 4
      when :back
        @rotation = (@rotation + 2) % 4
    end
    packet[:operations] ||= []
    packet[:operations] << {:name => 'turn', :return => @rotation}
  end

  def put!(packet, elem) # event: ship.put
    if @grid.grid[[@x, @y]] == :nothing
      @grid.grid[[@x, @y]] = elem
      packet[:operations] ||= []
      packet[:operations] << {:name => 'put', :return => {:name => elem, :x => @x, :y => @y}}
    else
      packet[:operations] ||= []
      packet[:operations] << {:name => 'put'}
      packet[:messages] ||= []
      packet[:messages] << {:type => 'warning', :message => 'Es ist kein Platz für ein weiteres Element'}

    end
  end

  def take!(packet) # event: ship.take
    elem = @grid.grid[[@x, @y]]
    if elem == :buoy || elem == :treasure
      @grid.grid[[@x, @y]] = :nothing
      packet[:operations] ||= []
      packet[:operations] << {:name => 'take', :return => {:name => elem, :x => @x, :y => @y}}
    else
      packet[:operations] ||= []
      packet[:operations] << {:name => 'take'}
      packet[:messages] ||= []
      packet[:messages] << {:type => 'warning', :message => 'Kein Objekt zum aufnehmen'}
    end
  end

  def look!(packet, direction) # event: ship.take
    coord = [@x, @y]
    next_coord = get_next_position
    case direction
      when :front
        coord = next_coord
      when :back
        coord[0] -= next_coord[0] - @x
        coord[1] -= next_coord[1] - @y
      when :left
        case @rotation
          when 3
            coord[0] += 1
          when 1
            coord[0] -= 1
          when 0
            coord[1] -= 1
          when 2
            coord[1] += 1
        end
      when :right
        case @rotation
          when 3
            coord[0] -= 1
          when 1
            coord[0] += 1
          when 0
            coord[1] += 1
          when 2
            coord[1] -= 1
        end
    end
    if coords_in_grid(coord) == false
      look_obj = :border
    else
      look_obj = @grid.grid[coord]
    end
    packet[:operations] ||= []
    packet[:operations] << {:name => 'look', :return => {:x => coord[0], :y => coord[1]}}
    look_obj
  end

  def move!(packet) # event: ship.move
    coord = get_next_position
    if coords_in_grid(coord)
      elem = @grid.grid[[coord[0], coord[1]]]
      case elem
        when :wave
          packet[:operations] ||= []
          packet[:operations] << {:name => 'move'}
          packet[:messages] ||= []
          packet[:messages] << {:type => 'warning', :message => 'Du wolltest in unruhige Gewässer fahren'}
        when :monster
          packet[:operations] ||= []
          packet[:operations] << {:name => 'exit'}
          packet[:messages] ||= []
          packet[:messages] << {:type => 'error', :message => 'Du bist auf einen Kraken gefahren'}
        else
          @x = coord[0]
          @y = coord[1]
          packet[:operations] ||= []
          packet[:operations] << {:name => 'move', :return => {:x => coord[0], :y => coord[1]}}
      end

    else
      packet[:operations] ||= []
      packet[:operations] << {:name => 'move'}
      packet[:messages] ||= []
      packet[:messages] << {:type => 'warning', :message => 'Du bist an das Ende der Welt gestoßen'}
    end
  end

  #TODO Move testet auf Objekte

  def coords_in_grid(coord)

    if coord[0] >= 0 && coord[0] < @grid.width && coord[1] >= 0 && coord[1]< @grid.height
      true
    else
      false
    end
  end

  def get_next_position
    x = @x
    y = @y
    case @rotation
      when 0
        x += 1
      when 1
        y += 1
      when 2
        x -= 1
      when 3
        y -= 1
    end
    [x, y]
  end

end