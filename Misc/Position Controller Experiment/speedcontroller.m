function F = speedcontroller(x,t)
F = x(1)*(1-exp(-t/x(2)));