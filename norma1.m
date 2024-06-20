function norma = norma1(A)
  [m,n] = size(A);
  somas = zeros(1,n);
  for j = 1:n
    for i = 1:m
      somas(j) = somas(j) + abs(A(i,j));
    endfor
  endfor
  maior = 0;
  for j = 1:n
    if (maior < somas(j))
      maior = somas(j);
    endif
  endfor
  norma = maior;
endfunction