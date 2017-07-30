function L = laguerre_polynomial(X,order_of_expansion )

[rowX,colX] = size(X);
L =   NaN((2 + order_of_expansion)*rowX , colX);

n = 2 + order_of_expansion;
for ii = 1 : rowX
    tt =  n * (ii-1)+1;
    L_n_minus_1  = ones(1,colX);
    L_n_x = L_n_minus_1  - X(ii,:);

     L(tt,:) = L_n_minus_1;
    L(tt+1,:) = L_n_x;
   
    for kk = 1 : order_of_expansion

        L_n_plus_1 = ((2*kk+1-X(ii,:)) .* L_n_x - kk * L_n_minus_1) ./ (kk + 1);
        L_n_minus_1 = L_n_x;
        L_n_x = L_n_plus_1;
        L(tt+kk+1,:) = L_n_plus_1;

    end
end
L = L(:);
% 
% dimX = numel(X);
% L = [];
% for ii = 1 : dimX
%     L_n_minus_1  = 1;
%     L_n_x = 1 - X(ii);
% 
%     L0 = [L_n_minus_1  ;
%         L_n_x ];
%     L = [L ; L0];
%     for n = 1 : order_of_expansion
%         L_n_plus_1 = ((2*n+1-X(ii)) * L_n_x - n * L_n_minus_1) / (n + 1);
%         L_n_minus_1 = L_n_x;
%         L_n_x = L_n_plus_1;
%         L = [L ; L_n_plus_1];
%     end
% end