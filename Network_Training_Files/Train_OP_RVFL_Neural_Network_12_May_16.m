function [Wout, WB ] = Train_OP_RVFL_Neural_Network_12_May_16( ...
    Xtrain, ...
    Ytrain , ...
    order_of_expansion , ...
    beta , ...
    polynomial_type , ...
    num_hidden ,...
    activation_function,...
    bias_flag,...
    direct_link_flag)

% this one introduces direct link from input layer (expanded in orthogonal
% polynomial) to output layer

% =========================================================================
% =========================================================================
[rowXtrain,colXtrain] = size(Xtrain);

Xstar = zeros((2 + order_of_expansion) * rowXtrain,colXtrain);

switch polynomial_type
    case 'chebyshev'
        for pp = 1 : colXtrain
            Xstar(:,pp) = chebyshev_polynomial(Xtrain(:,pp),order_of_expansion );
        end
    case 'hermite'
        for pp = 1 : colXtrain
            Xstar(:,pp) = hermite_polynomial(Xtrain(:,pp),order_of_expansion );
        end
    case 'legendre'
        for pp = 1 : colXtrain
            Xstar(:,pp) = legendre_polynomial(Xtrain(:,pp),order_of_expansion );
        end
    case 'laguerre'
        for pp = 1 : colXtrain
            Xstar(:,pp) = laguerre_polynomial(Xtrain(:,pp),order_of_expansion );
        end
end
% remove constant rows == 1 from FE. Save only the first row.
vector=[];
for ii = 1 : rowXtrain-1
    vector = [ vector (order_of_expansion + 2)* ii+1];
end
Xstar(vector,:)=[];
[rowXc,colXc ]= size(Xstar);

%     randomly generate input weights for network
Win = rand(num_hidden,rowXc)*2-1;
if bias_flag == 0;
    Bias = zeros(num_hidden,1);
else bias_flag == 1;
    Bias = rand(num_hidden,1);
end

XX = (Win * Xstar+repmat(Bias,1,colXc));

switch activation_function
    case 'linear'
        %                 H(ii,kk) = Win(ii,:) * Xstar(:,kk);
        %         H = Win * Xstar+repmat(Bias,1,colXtrain);
        H = XX;
    case 'tan_sig'
        %                 H(ii,kk) = tanh(Win(ii,:) * Xstar(:,kk)) + Bias(ii);
        %         H = tanh(Win * Xstar+repmat(Bias,1,colXc));
        H = tanh(XX);
    case 'log_sig'
        %                 H(ii,kk) = 1 ./ (1 + exp(-(Win(ii,:) * Xstar(:,kk)) + Bias(ii)));
        %         H = 1./ (1+exp(-(Win * Xstar+repmat(Bias,1,colXc))));
        H = 1./(1+exp(-XX));
    case 'rad_bas'
        %                 H(ii,kk) = tanh(Win(ii,:) * Xstar(:,kk)) + Bias(ii);
        %         H = exp(-(Win * Xstar)+repmat(Bias,1,colXc).^2);
        H = radbas(XX);
    case 'tri_bas'
        %         XX = (Win * Xstar+repmat(Bias,1,colXc));
        %         %         ones(size(Xstar))
        %         H = ones(size(XX))-abs(XX);
        %         [a,b] = find(H<0);
        %         for i = 1:numel(a)
        %             H(a(i),b(i)) = 0;
        %         end
        H = tribas(XX);
end
%     end
% end%


% training
if direct_link_flag == 0;
    Wout = Ytrain * H' * pinv( H * H' + beta*diag(ones(num_hidden,1)));
else direct_link_flag == 1;
    Hdirect = [Xstar ; H];
    Wout = Ytrain * Hdirect' * pinv( Hdirect * Hdirect' + beta*eye(num_hidden+rowXc));
end

WB.W = Win;
WB.B = Bias;
return