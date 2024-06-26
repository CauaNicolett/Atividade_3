format long;

% ITEM 1 -------------------------------------

vetor_m = [10,100,200,300];
matriz = item_a(vetor_m);

% INICIALIZANDO MATRIZES DO ITEM 4 -----------

% Gerando as transpostas
for i = 1:80
  transposta = strcat('AT', num2str(i));
  matriz_nome = strcat('A', num2str(i));
  matriz.(transposta) = matriz.(matriz_nome)';
endfor

% Gerando 80 vetores aleatórios de tamanho n
for i = 1:80
  aleatorio = strcat('l', num2str(i));
  matriz_nome = strcat('A', num2str(i));
  tamanho = size(matriz.(matriz_nome))(2);
  vet.(aleatorio) = 1 - 2*rand(tamanho,1);
endfor

% Multiplicando pelas transpostas
% (Multiplicamos pela própria A, a transposta da transposta).
for i = 1:80
  produto = strcat('x', num2str(i));
  vetor_l = strcat('l', num2str(i));
  matriz_nome = strcat('A', num2str(i));
  vet.(produto) = matriz.(matriz_nome)*vet.(vetor_l);
endfor

% Calculando vetores b associados
for i = 1:80
  associado = strcat('b', num2str(i));
  vetor_x = strcat('x', num2str(i));
  transposta = strcat('AT', num2str(i));
  vet.(associado) = matriz.(transposta)*vet.(vetor_x);
endfor

% INICIALIZANDO MATRIZES DO ITEM 4 (FIM) -----------

% Dê um número entre 1 e 80
%while true
  
  indice = input("Digite um inteiro de 1 a 80: ");
  if (isscalar(indice) && isnumeric(indice)
    && indice <= 80 && indice >= 1 && mod(indice, 1) == 0)
    
    % Definindo a matriz
    A = matriz.(strcat('A', num2str(indice)));

    % Definindo o tamanho n
    m = size(A)(1);

    % ITEM 2 -------------------------------------
    % Definindo um vetor b aleatório de tamanho n com entradas entre -1 e 1:
    b = 1 - 2*rand(m,1);

    A2 = A'*A;
    c = A'*b;

    % Usando LU
    [L, U, P] = lu(A2);
    X3 = P*c;
    X2 = resolver_triangular(L, X3, "inferior");
    X = resolver_triangular(U, X2, "superior");

    % Usando Cholesky
    G = chol(A2, "upper");
    Y2 = resolver_triangular(G', c, "inferior");
    Y = resolver_triangular(G, Y2, "superior");

    % Usando QR
    [Q, R] = qr(A);
    numero_colunas = size(R)(2);
    c_hat = (Q'*b)(1:numero_colunas); R_hat = R(1:numero_colunas,:);
    Z = resolver_triangular(R_hat, c_hat, "superior");

    % ITEM 3 -------------------------------------

    % Calculando resíduos usando norma 1
    norma_b = norma1(b);
    residuoX = norma1(A*X - b)/norma_b;
    residuoY = norma1(A*Y - b)/norma_b;
    residuoZ = norma1(A*Z - b)/norma_b;

    % A tabela comparativa é da forma
    % [rx-rx   rx-ry   rx-rz]
    % [ry-rx   ry-ry   ry-rz]
    % [rz-rx   rz-ry   rz-rz]
    % onde rx é residuoX, ry é resíduoY e rz é residuoZ.

    residuos = [residuoX, residuoY, residuoZ];
    tabela_comparativa = ones(3);
    tabela_comparativa(1,:) = residuoX*tabela_comparativa(1,:) - residuos;
    tabela_comparativa(2,:) = residuoY*tabela_comparativa(2,:) - residuos;
    tabela_comparativa(3,:) = residuoZ*tabela_comparativa(3,:) - residuos;

    % Atualizando A para a sua transposta
    A = A';
    % Atualizando a definição do vetor b
    b = vet.(strcat('b', num2str(indice)));

    % Instruções:
    % vet.l1 é o vetor lambda* gerado para a matriz matriz.AT1;
    % vet.x1 é o produto da transposta de matriz.AT1 por lambda;
    % vet.b1 é o produto de matriz.AT1 por vet.x1;
    % Você pode usar números de 1 a 80.

    % Agora basta resolver o problema de minimização
    % Não confundir lambda* gerado aleatoriamente com o
    % lambda do método de multiplicadores de Lagrange.

    % Usando sistema de ponto sela (resolver A*A'*lambda = -b
    % usando Cholesky, porque esqueci como faz gradiente conjugado

    G = chol(A*A', "upper");
    aux = resolver_triangular(G', -b, "inferior");
    lambda = resolver_triangular(G, aux, "superior");

    x_min = -A'*lambda;

    % Usando fatoração QR
    escolha = A;
  else
  error("ERR0");
  endif
%endwhile