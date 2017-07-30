function H = hermite_polynomial(X,order_of_expansion )

[rowX,colX] = size(X);
H =   NaN((2 + order_of_expansion)*rowX , colX);

k = 2 + order_of_expansion;

for ii = 1 : rowX
    
    H_n_minus_1  = ones(1,colX);;
    H_n_x = X(ii,:);

    tt =  k * (ii-1)+1;% : n*ii
    
    H(tt,:) = H_n_minus_1;
    H(tt+1,:) = H_n_x;
    
    for n = 1 : order_of_expansion
        H_n_plus_1 = X(ii,:) .* H_n_x - n * H_n_minus_1;
        H_n_minus_1 = H_n_x;
        H_n_x = H_n_plus_1;
    H(tt+n+1,:) = H_n_plus_1;
    
    end
end
H=H(:);
% 
% dimX = numel(X);
% H = [];
% for ii = 1 : dimX
%     H_n_minus_1  = 1;
%     H_n_x = X(ii);
% 
%     H0 = [H_n_minus_1  ;
%         H_n_x ];
%     H = [H ; H0];
%     for n = 1 : order_of_expansion
%         H_n_plus_1 = X(ii) * H_n_x - n * H_n_minus_1;
%         H_n_minus_1 = H_n_x;
%         H_n_x = H_n_plus_1;
%         H = [H ; H_n_plus_1];
%     end
% end