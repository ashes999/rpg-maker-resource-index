# Source: http://forums.rpgmakerweb.com/index.php?/topic/415-proximity-events/?hl=%2Bproximity+%2Bevents
##Proximity Detection Script
#Configuration consists of setting a default Proximity Range within the script
#Usage: By setting an event to Parallel Process and using a Conditional Branch
#          within that does the script call: Proxy.inprox?(@event_id) you can have
#          the commands within fire off when the player is within or not within
#          proximity.
#
#Common Usage:
#       Proxy.inprox?(@event_id)        for checking for player within default range
#       Proxy.inprox?(@event_id, #) for checking for player within # range
#       Proxy.inprox_d?(@event_id, [#]) for directional usage
#       Proxy.inprox_r?(@event_id, width, height)  rectangular checking with event
#                                                                                          as an origin (works best with
#                                                                                          odd numbers)
#
# All calls return true if within range and false when not
#
#Advanced Usage:
#       Proxy.inprox(nil, #, x, y) for checking for player within # range
#       of a x,y point on the map
#
#Any errors involving Game_Interpreter usually means the script call was mispelt
#  so double-check if that occurs
#------#
#-- Script by: V.M of D.T
#--- Free to use in any project with credit given


class Proxy
  #Default radius of detection:
  PROXYRANGE = 3
  #----#
  def self.inprox?(id, distance = PROXYRANGE, x = 0, y = 0)
        if id != nil
          x = $game_map.events[id].x
          y = $game_map.events[id].y
        end
        iter = x + distance + 1
        iter2 = 0
        half = x
        x = x - distance
        while x < iter
          ylow = y - iter2  
          yhigh = y + iter2
          if $game_player.x == x and $game_player.y >= ylow and $game_player.y <= yhigh
                return true
          end
          x += 1
          if x > half then iter2 -= 1 else iter2 += 1 end
        end
        return false
  end
  def self.inprox_d?(id, distance = PROXYRANGE, x = 0, y = 0)
        if self.inprox?(id, distance, x, y) then else return false end
        x1 = $game_player.x; x2 = $game_map.events[id].x
        y1 = $game_player.y; y2 = $game_map.events[id].y
        x1 > x2 ? xx = x1 - x2 : xx = x2 - x1
        y1 > y2 ? yy = y1 - y2 : yy = y2 - y1
        case $game_map.events[id].direction
        when 2
          if $game_player.y > $game_map.events[id].y then
                if yy >= xx then return true end end
        when 4
          if $game_player.x < $game_map.events[id].x then
                if xx >= yy then return true end end
        when 6
          if $game_player.x > $game_map.events[id].x then
                if xx >= yy then return true end end
        when 8
          if $game_player.y < $game_map.events[id].y then
                if yy >= xx then return true end end
        end
        return false
  end
  def self.inprox_r?(id, width, height)
        width % 2 == 0 ? hwidth = width / 2 : hwidth = (width - 1) / 2
        height % 2 == 0 ? hheight = height / 2 : hheight = (height - 1) / 2
        x = $game_map.events[id].x - hwidth
        y = $game_map.events[id].y - hheight
        if $game_player.x >= x and $game_player.x < (x + width)
          if $game_player.y >= y and $game_player.y < (y + height)
                return true
          end
        end
        return false
  end
end