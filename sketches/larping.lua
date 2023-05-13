--- fun dual arpeggiator
-- in1 voltage to quantize
-- in2 window to change scale
-- out1 voltage quantized to scale
-- out2 ar envelope when note changes
-- out3 free running sequence matching selected scale
-- out4 ar envelope when note changes

s = sequins

maj = s{0,2,4,s{7,9}}
majr = s{9,7,4,2,0}
min = s{0,3,5,s{7,11}}
minr = s{11,7,5,3,0}

majQ = {0,2,4,7,9}
minQ = {0,3,5,7,11}

arps = {minr, min, maj, majr} 
qs = {minQ, minQ, majQ, majQ}

arp = arps[3]
q = qs[3]

-- customize while playing
o = 12 --offset
rate = 1 -- lower number = faster, can do fractions

env_length1 = 0.8 -- length of first ar envelope
ar_level1 = 2 -- voltage of first ar envelope

env_length2 = 0.8 -- length of second ar envelope
ar_level2 = 2 -- voltage of second ar envelope

function maybe_offset(n)
  if (math.random() > 0.8) then
    return n+o
  elseif (math.random() > 0.6) then
    return n-o
  else
    return n
  end
end

function new_note()
  return maybe_offset(arp()) / 12
end

function play_note(v)
  output[3].volts = v
end

function run_arp()
  return clock.run(
    function()
      while true do
        clock.sync(rate)
        local note = new_note()
        play_note( note )
        output[4]()
      end
    end
  )
end

-- update continuous quantizer
input[1].scale = function(s)
  output[1].volts = s.volts
  output[2]()
end

input[2].window = function(win, dir)
  arp = arps[win]
  q = qs[win]
end

function init()
  input[1].mode('scale', q)
  input[2].mode('window', {-2,-0.1,2})
  output[2].action = ar(0.01, env_length1, ar_level1)
  myarp = run_arp(arp)
  output[4].action = ar(0.01, env_length2, ar_level2)
end
