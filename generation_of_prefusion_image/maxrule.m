function Y = maxrule(M1, M2)
 		mm = (abs(M1)) > (abs(M2));
  	Y  = (mm.*M1) + ((~mm).*M2);

