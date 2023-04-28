--- just friends arpeggiator
-- from "music in the time of functional async programming" maps

s = sequins

myarp = {}
myarp2 = {}
skal = s{0,2,4,7,9}

function init()
  ii.jf.mode(1)
  myarp = run_arp(play_jf_note)
end

function play_jf_note(v) 
  ii.jf.play_note(v, 5)
end

function run_arp(fn)
  return clock.run(
    function()
      while true do
        clock.sync(1/4)
        fn( skal()/12 )
      end
    end
  )
end
