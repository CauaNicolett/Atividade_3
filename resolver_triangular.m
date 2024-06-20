function x = resolver_triangular(T, b, tipo)
    % Verificar se T é uma matriz triangular
    [m, n] = size(T);
    if m ~= n
        error('A matriz T deve ser quadrada.');
    end
    
    % Inicializar o vetor de solução
    x = zeros(n, 1);
    
    % Resolver sistema triangular inferior
    if strcmp(tipo, 'inferior')
        if T(1,1) == 0
            error('A matriz T é singular.');
        end
        x(1) = b(1)/T(1,1);
        for i = 2:n
            if T(i, i) == 0
                error('A matriz T é singular.');
            end
            x(i) = (b(i) - T(i, 1:i-1) * x(1:i-1)) / T(i, i);
        end
    
    % Resolver sistema triangular superior
    elseif strcmp(tipo, 'superior')
        if T(n, n) == 0
            error('A matriz T é singular.');
        end
        x(n) = b(n)/T(n,n);
        for i = n-1:-1:1
            if T(i, i) == 0
                error('A matriz T é singular.');
            end
            x(i) = (b(i) - T(i, i+1:n) * x(i+1:n)) / T(i, i);
        end
    
    % Tipo desconhecido
    else
        error('O tipo de sistema deve ser "inferior" ou "superior".');
    end
end
