--- arp quantizer & progressionator
-- scott stahl 2023
-- in1: clock pulse which will advance arp selection and randomize some of the envelope values
-- in2: voltage to quantize
-- out1: in2 quantized to current arp continuously
-- out2: triangle envelope on note change
-- out3: envelope fired on note change
-- out4: reverse envelope fire on note change

s = sequins

-- adjust these variables to taste
seq = s{
  'majTri'
, 'maj7th'
, 'dom7th'
, 'min7th'
, 'dim7th'
}

env_length1 = 0.8 -- length of first ar envelope
ar_level1 = 2 -- voltage of first ar envelope

env_length2 = 0.8 -- length of second ar envelope
ar_level2 = 2 -- voltage of second ar envelope

arp_progression = {
  majTri = {0,4,7}
, maj7th = {0,4,7,11}
, dom7th = {0,4,7,10}
, min7th = {0,3,7,10}
, dim7th = {0,3,6,9}
}

function requantize()
  local next = seq()
  print('new arp:', next)
  input[2].mode('scale', arp_progression[next])
end

function randomize_length_and_v()
  env_length1 = math.random(1, 10) / 10
  ar_level1 = math.random(1, 3)
  print('ar1 length, level:', env_length1, ar_level1)
  env_length2 = math.random(1, 10) / 10
  ar_level2 = math.random(1, 3)
  print('ar2 length, level:', env_length2, ar_level2)
end

-- change scale on 1v increase
input[1].change = function(state)
  requantize()
  randomize_length_and_v()
end

-- update continuous quantizer
input[2].scale = function(s)
  output[1].volts = s.volts
  -- fire all output modulation events on note change
  output[2]()
  output[3]()
  output[4]()
end

function init()
  input[1].mode('change',1,0.1,'rising')
  input[2].mode('scale', arp_progression[seq[1]])
  output[2].action = ar((env_length1 / 2), (env_length2 / 2), (ar_level1 + ar_level2) / 2) -- even triangle
  output[3].action = ar(0.01, env_length1, ar_level1) -- quick attack long release on note change
  output[4].action = ar(env_length2, 0.01, ar_level2) -- long attack quick release on note change
end
