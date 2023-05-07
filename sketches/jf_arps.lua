--- just friends arpeggiator

s = sequins

maj = s{0,2,4,s{7,9}}
majr = s{9,7,4,2,0}
min = s{0,3,5,s{7,11}}
minr = s{11,7,5,3,0}
o1min = s{0,0,0,5,5,5,7,7,7}
o1maj = s{0,0,0,4,4,4,7,7,7}

-- customize while playing
skal = maj -- or majr, or min, or minr - skal2 will match
o = 12 --offset
rate = 1
voices = 2

-- randomize order of arp?

function play_jf_note(v) 
  ii.jf.play_note(v, 3)
end

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
  return maybe_offset(skal()) / 12
end

function play_notes(n)
  for i = 1, n do
    local note = new_note()
    play_jf_note( note )
  end
end

function output_values()
  if (skal == maj or skal == majr) then
    output[1].volts = o1maj() / 12
  else
    output[1].volts = o1min() / 12
  end
end

function run_arp()
  return clock.run(
    function()
      while true do
        clock.sync(rate)
        play_notes(voices)
        output_values()
      end
    end
  )
end

function init()
  ii.jf.mode(1)
  myarp = run_arp()
end
