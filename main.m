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
function escolha = escolher(matriz, vet)
  
  exp = 1;
  exptxt = "ATIVADO";
  casosteste = 1000; casos = casosteste;
  while true
    fprintf("Instruções: Digite 0 para sair do programa, ou -1 para acessar os resultados calculados.\n");
    fprintf("Modo experimento: %s. Digite -2 para mudar o estado desta variável.\n", exptxt);
    indice = input("Digite um número de 1 a 80: ");
    switch indice
      case 0
        break
      case -2
        switch exp
          case 1
            exp = 0;
            exptxt = "DESATIVADO";
            casos = 1;
          case 0
            exp = 1;
            exptxt = "ATIVADO";
            casos = casosteste;
        endswitch
      case -1
        while true
          fprintf("Entradas:\n");
          fprintf("0 - Inserir uma nova matriz;\n");
          fprintf("1 - Imprimir matriz;\n");
          fprintf("2 - Exibir resultados do pŕoblema de quadrados mínimos;\n");
          fprintf("3 - Exibir resultados do problema de solução de norma mínima.\n");
          indice = input("Entrada: ")
          switch indice
            case 0
              break;
            case 1
              disp("Matriz:\n")
              matriz.(strcat('A', num2str(indice)))
              fprintf("Dimensões: %d x %d.\n", m, n);
            case 2
              disp("Tabela comparativa de resíduos (quadrados mínimos)\n");
              tabela_comparativa
              disp("Tempos.\n");
              tempos1
            case 3
              disp("Tabela comparativa de resíduos (solução de norma mínima)\n");
              tabela_comparativamin
              disp("Tempos.\n");
              tempos2
              disp("Razões na solução de norma mínima, usando multiplicadores de Lagrange e fatoração QR, respectivamente.\n");
              razoes
              disp("Erros na solução de norma mínima, usando multiplicadores de Lagrange e fatoração QR, respectivamente.\n");
              erros
          endswitch
        endwhile
      otherwise
        if (isscalar(indice) && isnumeric(indice)
        && indice <= 80 && indice >= 1 && mod(indice, 1) == 0)
        
        % Definindo a matriz
        A = matriz.(strcat('A', num2str(indice)));

        % Conseguindo os tamanhos m, n
        m = size(A)(1);
        n = size(A)(2);

        % ITEM 2 -------------------------------------
        % Definindo um vetor b aleatório de tamanho n com entradas entre -1 e 1:
        b = 1 - 2*rand(m,1);

        A2 = A'*A;
        c = A'*b;

        % Usando LU
        
        tic;
        
        for i = 1:casos
          [L, U, P] = lu(A2);
        endfor
      
        pretempolu = toc/casos;
        tic;
        
        for i = 1:casos
          X3 = P*c;
          X2 = resolver_triangular(L, X3, "inferior");
          X = resolver_triangular(U, X2, "superior");
        endfor
        
        tempolu = toc/casos;

        % Usando Cholesky
        
        tic;
        
        for i = 1:casos
          G = chol(A2, "upper");
        endfor
        
        pretempochol = toc/casos;
        tic;
        
        for i = 1:casos
          Y2 = resolver_triangular(G', c, "inferior");
          Y = resolver_triangular(G, Y2, "superior");
        endfor
        
        tempochol = toc/casos;

        % Usando QR
        
        tic;
        
        for i = 1:casos
          [Q, R] = qr(A);
        endfor
        pretempoqr = toc/casos;
        tic;
        
        for i = 1:casos
          numero_colunas = size(R)(2);
          c_hat = (Q'*b)(1:numero_colunas); R_hat = R(1:numero_colunas,:);
          Z = resolver_triangular(R_hat, c_hat, "superior");
        endfor
        
        tempoqr = toc/casos;
        
        tempos1 = [pretempolu, pretempochol, pretempoqr;
                  tempolu, tempochol, tempoqr
                  pretempolu+tempolu, pretempochol+tempochol, pretempoqr+tempoqr];

        % ITEM 3 -------------------------------------

        % Calculando resíduos usando norma 2
        norma_b = norm(b);
        residuoX = norm(A*X - b)/norma_b;
        residuoY = norm(A*Y - b)/norma_b;
        residuoZ = norm(A*Z - b)/norma_b;

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
        
        % ITEM 4 -------------------------------------

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
        
        tic;
        
        for i = 1:casos
          G = chol(A*A', "upper");
        endfor
        
        pretempo2ml = toc/casos;
        tic;
        
        for i = 1:casos
          aux = resolver_triangular(G', -b, "inferior");
          lambda = resolver_triangular(G, aux, "superior");

          x_min_ml = -A'*lambda;
        endfor
        
        tempo2ml = toc/casos;

        % Usando fatoração QR
        
        tic;
        
        for i = 1:casos
          [Q,R] = qr(A');
        endfor
        
        pretempo2qr = toc/casos;
        tic;
        
        for i = 1:casos
          numero_colunas = size(R)(2);
          Q_hat = Q(:, 1:numero_colunas); R_hat = R(1:numero_colunas,:);
          y = resolver_triangular(R_hat', b, "inferior");
          x_min_qr = Q_hat*y;
        endfor
        
        tempo2qr = toc/casos;
        
        tempos2 = [pretempo2ml, pretempo2qr;
                  tempo2ml, tempo2qr;
                  pretempo2ml + tempo2ml, pretempo2qr + tempo2qr];
        
        % Comparando resultados
        % [x_min_ml, x_min_qr, A \ b]
         
        % ITEM 5 -------------------------------------

        % Calculando resíduos usando norma 2
        norma_b = norm(b);
        residuoml = norm(A*x_min_ml - b)/norma_b;
        residuoqr = norm(A*x_min_qr - b)/norma_b;

        % A tabela comparativa é da forma
        % [rml - rml   rml - rqr]
        % [rqr - rml   rqr - rqr]
        % onde rml é residuoml, rqr é resíduoqr.

        residuosmin = [residuoml, residuoqr];
        tabela_comparativamin = ones(2);
        tabela_comparativamin(1,:) = residuoml*tabela_comparativamin(1,:) - residuosmin;
        tabela_comparativamin(2,:) = residuoqr*tabela_comparativamin(2,:) - residuosmin;
        
        % Calculando erros
        
        % Solução exata
        x_exato = vet.(strcat('x', num2str(indice)));
        
        % Razão entre soluções
        razaoml = norm(x_min_ml)/norm(x_exato);
        razaoqr = norm(x_min_qr)/norm(x_exato);
        
        razoes = [razaoml, razaoqr];
        
        % Erro entre soluções
        erroml = norm(x_exato - x_min_ml)/norm(x_exato);
        erroqr = norm(x_exato - x_min_qr)/norm(x_exato);
        
        erros = [erroml, erroqr];
 
      else
      disp("Erro: entrada inválida. Certifique-se de que ela é um número inteiro de 1 a 80.");
      endif
    endswitch
  endwhile
endfunction