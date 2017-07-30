function T = chebyshev_polynomial(X,order_of_expansion )

[rowX,colX] = size(X);
T =   NaN((2 + order_of_expansion)*rowX , colX);

n = 2 + order_of_expansion;


for ii = 1 : rowX
    
    tt =  n * (ii-1)+1;% : n*ii
    T_n_minus_1  = ones(1,colX);
    T_n_x = X(ii,:);
    
    T(tt,:) = T_n_minus_1;
    T(tt+1,:) = X(ii,:);
    
    for kk = 1 : order_of_expansion
        T_n_plus_1 = 2 * X(ii,:) .* T_n_x - T_n_minus_1;
        T_n_minus_1 = T_n_x;
        T_n_x = T_n_plus_1;

        jj = n * (ii-1)+1 : n*ii;
        T(tt+kk+1,:) = T_n_plus_1;
    end
    
end
T = T(:);
% dimX = numel(X);
% T = [];
% for ii = 1 : dimX
%     T_n_minus_1  = 1;
%     T_n_x = X(ii);
% 
%     T0 = [T_n_minus_1  ;
%         T_n_x ];
%     T = [T ; T0];
%     for kk = 1 : order_of_expansion
%         T_n_plus_1 = 2 * X(ii) * T_n_x - T_n_minus_1;
%         T_n_minus_1 = T_n_x;
%         T_n_x = T_n_plus_1;
%         T = [T ; T_n_plus_1];
%     end
% end