function [Ytestflelm] = Simulate_OP_RVFL_Neural_Network_12_May_16( ...
    Xtest , ...
    Wout, ...
    WB, ...
    order_of_expansion , ...
    polynomial_type , ...
    activation_function,...
    direct_link_flag)

% =========================================================================
% =========================================================================

% Weights and biases
Win = WB.W;
Bias = WB.B;

% testing
%     for testing data
[rowXtest,colXtest] = size(Xtest);
Xstar_test = zeros(((2 + order_of_expansion)) * rowXtest,colXtest);

switch polynomial_type
    case 'chebyshev'
        for pp = 1 : colXtest
            Xstar_test(:,pp) = chebyshev_polynomial(Xtest(:,pp),order_of_expansion );
        end
    case 'hermite'
        for pp = 1 : colXtest
            Xstar_test(:,pp) = hermite_polynomial(Xtest(:,pp),order_of_expansion );
        end
    case 'legendre'
        for pp = 1 : colXtest
            Xstar_test(:,pp) = legendre_polynomial(Xtest(:,pp),order_of_expansion );
        end
    case 'laguerre'
        for pp = 1 : colXtest
            Xstar_test(:,pp) = laguerre_polynomial(Xtest(:,pp),order_of_expansion );
        end
end
% remove constant rows == 1 from FE. Save only the first row.
vector=[];
for ii = 1 : rowXtest-1
    vector = [ vector (order_of_expansion + 2)* ii+1];
end
Xstar_test(vector,:)=[];

% for kk = 1 : colXtest
%     for ii = 1 : (num_hidden)
switch activation_function
    case 'linear'
        %                 Htest(ii,kk) = Win(ii,:) * Xstar_test(:,kk);
        Htest = Win * Xstar_test+repmat(Bias,1,colXtest);
    case 'tan_sig'
        %                 Htest(ii,kk) = tanh(Win(ii,:) * Xstar_test(:,kk)) + Bias(ii);
        Htest = tanh(Win * Xstar_test+repmat(Bias,1,colXtest));
    case 'log_sig'
        %                 Htest(ii,kk) = 1 ./ (1 + exp(-(Win(ii,:) * Xstar_test(:,kk)) + Bias(ii)));
        Htest = 1./ (1+exp(-(Win * Xstar_test+repmat(Bias,1,colXtest))));
    case 'rad_bas'
        %                 H(ii,kk) = tanh(Win(ii,:) * Xstar(:,kk)) + Bias(ii);
        Htest = exp(-(Win * Xstar_test)+repmat(Bias,1,colXtest).^2);
        
    case 'tri_bas'
        XX = (Win * Xstar_test+repmat(Bias,1,colXtest));
        %         ones(size(Xstar))
        Htest = ones(size(XX))-abs(XX);
        [a,b] = find(Htest<0);
        for i = 1:numel(a)
            Htest(a(i),b(i)) = 0;
        end
end
%     end
% end%

if direct_link_flag == 1
    H = [Xstar_test ; Htest ];
else
    H = Htest;
end
Ytestflelm = Wout * H;
% =========================================================================
