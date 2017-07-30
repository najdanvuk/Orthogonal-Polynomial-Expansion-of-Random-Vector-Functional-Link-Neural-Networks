function P = legendre_polynomial(X,order_of_expansion )

[rowX,colX] = size(X);
P =   NaN((2 + order_of_expansion)*rowX , colX);

k = 2 + order_of_expansion;

for ii = 1 : rowX
    P_n_minus_1  = ones(1,colX);
    P_n_x = X(ii,:);
    
    tt =  k * (ii-1)+1;% : n*ii
    
    P(tt,:) = P_n_minus_1;
    P(tt+1,:) = P_n_x;
    
    for n = 1 : order_of_expansion
        P_n_plus_1 = ((2*n+1) * X(ii,:) .* P_n_x - n * P_n_minus_1) ./ (n + 1);
        P_n_minus_1 = P_n_x;
        P_n_x = P_n_plus_1;
        P(tt+n+1,:) = P_n_plus_1;
    end
end
P = P(:);
% 
% dimX = numel(X);
% P = [];
% for ii = 1 : dimX
%     P_n_minus_1  = 1;
%     P_n_x = X(ii);
% 
%     P0 = [P_n_minus_1  ;
%         P_n_x ];
%     P = [P ; P0];
%     for n = 1 : order_of_expansion
%         P_n_plus_1 = ((2*n+1) * X(ii) * P_n_x - n * P_n_minus_1) / (n + 1);
%         P_n_minus_1 = P_n_x;
%         P_n_x = P_n_plus_1;
%         P = [P ; P_n_plus_1];
%     end
% end
