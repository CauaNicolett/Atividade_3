function matriz = item_a(valoresm)
% Verifica se as entradas são válidas
  %--- o vetor valoresm deve ser 1x4
if (size(valoresm)(1) != 1 || size(valoresm)(2) != 4)
  error("O tamanho da entrada deve ser 1x4");
  %--- m deve ser divisível por 10
elseif (mod(valoresm, 10) != 0)
  error("As entadas do vetor valoresm devem ser divisíveis por 10");
endif
% Define quantos valores diferentes há de m e n.
quantidadem = size(valoresm)(2);
quantidadeMatrizes = 80;

% Cria vetor de índices para valores de n.
indicesn = zeros(1,quantidadeMatrizes);
for i = 1:quantidadeMatrizes;
 indicesn(i) = randi([1,5]);
endfor

% Cria matrizes mxn.
contador = 1;
for k = 1:4
 m = valoresm(k);
 valoresn = [1, m/10, m/2, 9*m/10, (m-1)];
 for i = 1:20
   n = valoresn(indicesn(contador));
   % Usa o contador para gerar o nome da matriz
   matrizNome = strcat('A', num2str(contador));
   matrizNomeModificada = strcat('a', num2str(contador));
   matriz.(matrizNome) = rand(m,n);
   if (n != 1)
     ultimaColuna = matriz.(matrizNome)(:,n);
     ultimaColuna = (10^(-5))*ultimaColuna;
     mediaColunas = zeros(m,1);
     for j = 1:n-1
       mediaColunas = mediaColunas + matriz.(matrizNome)(:,j);
     endfor
     mediaColunas = mediaColunas/(n-1);
     ultimaColuna = ultimaColuna + mediaColunas;
     matriz.(matrizNomeModificada) = matriz.(matrizNome);
     matriz.(matrizNomeModificada)(:,n) = ultimaColuna;
   endif
   contador++;
  endfor
endfor
endfunction
