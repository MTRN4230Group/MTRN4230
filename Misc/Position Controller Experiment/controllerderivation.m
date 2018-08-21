csys = tf(((280000*2*pi)/(24*8192)),[0.145 1 0])
dsys = c2d(csys,0.004,'zoh')
step(csys, '-', dsys, '-')
