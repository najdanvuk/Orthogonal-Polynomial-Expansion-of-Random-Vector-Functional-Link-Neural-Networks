% =========================================================================
% =========================================================================
% =========================================================================
% These files are free for non-commercial use. If commercial use is
% intended, you can contact me at e-mail given below. The files are intended 
% for research use by experienced Matlab users and includes no warranties 
% or services.  Bug reports are gratefully received. 
% I wrote these files while I was working as scientific researcher
% with University of Belgrade - Innovation Center at Faculty of Mechanical 
% Engineering so as to test my research ideas and show them to wider 
% community of researchers. None of the functions are meant to be optimal, 
% although I tried to speed up execution. You are wellcome to use these 
% files for your own research provided you mention their origin. If you 
% would like to contact me, my e-mail is given below. 
% =========================================================================
% =========================================================================
% All rights reserved by: Dr. Najdan Vukovic
% contact e-mail: najdanvuk@gmail.com or nvukovic@mas.bg.ac.rs
% =========================================================================
% =========================================================================
% Cite as: N. Vukovic, M.Petrovic, Z.Miljkovic, Orthogonal Polynomial
% Expanded Random Vector Functional Link Neural Networks for Regression 
% and Classification,Working paper.
% =========================================================================
% =========================================================================
% This one tests OP-RVFL w/out direct link from  input layer (expanded in 
% orthogonal polynomial) to output layer for regression. You can put different
% datasets. 
% =========================================================================
% Note: you need to add all folders to path (select folder, right click=> add folders...)
% =========================================================================
% =========================================================================
clc,clear, close all
% rng('shuffle')
% =========================================================================
% =========================================================================
% CHOOSE ORTHOGONAL POLYNOMIAL
polynomial_type = 'chebyshev'
% polynomial_type = 'hermite'
% polynomial_type = 'legendre'
% polynomial_type = 'laguerre'
% =========================================================================
% =========================================================================
% CHOOSE ACTIVATION FUNCTION
activation_function = 'tan_sig'
% activation_function = 'log_sig'
% activation_function = 'linear'
% activation_function = 'rad_bas'
% activation_function = 'tri_bas'
% =========================================================================
% =========================================================================
bias_flag = 0;           % W/OUT BIAS?
direct_link_flag = 1;    % W/OUT DIRECT LINK? (DIRECT LINK IMPROVES PERFORMANCE OF NETWORK)
pct_of_examples = .7;    % PCT OF DATA USED FOR TRAINING
order_of_expansion = 2;  % ORDER OF EXPANSION OF ORTHOGONAL POLYNOMIAL
beta = .000100;          % RIDGE REGRESSION PARAMETER
num_hidden = 10;          % NUMBER OF NEURONS IN THE HIDDEN LAYER
NumTrials = 20;          % NUMBER OF TRIALS 
% =========================================================================
% =========================================================================
fprintf('OP RVFL NN for Regression: # of Trials:%d\n ', NumTrials)
% =========================================================================
% =========================================================================
%                           T E S T   S E T S
%==========================================================================
%==========================================================================
% You can put what ever dataset you like, as long as you have input and
% output defined.
% Note: X (regressors x number of examples) ; Y(output x number of examples)
%==========================================================================
%==========================================================================
% In this case, just uncomment dataset you'd like to use.
%==========================================================================
%==========================================================================
% auto_mpg_dataset
% X = mpgset(:,2:end)';
% Y = mpgset(:,1)';
% clear mpgset
%==========================================================================
%==========================================================================
% weather_ankara_data
% X = data_ankara(:,1:end-1)';
% Y = data_ankara(:,end)';
% clear data_ankara
%==========================================================================
%==========================================================================
% weather_izmir
% X = weather_izmir_data(:,1:end-1)';
% Y = weather_izmir_data(:,end)';
% clear weather_izmir_data
%==========================================================================
%==========================================================================
abalone_dataset
X = abaloneset(:,1:end-1)';
Y = abaloneset(:,end)';
clear abaloneset
%==========================================================================
%==========================================================================
%==========================================================================
%==========================================================================
% Scale data
X = (X-min(X(:)))./(max(X(:))-min(X(:)));   % to [0,1]
Y = (Y-min(Y(:)))./(max(Y(:))-min(Y(:)));   % to[0,1]

Xall = X ; Yall = Y;
% =========================================================================
% =========================================================================
%                       T R A I N   N E T W O R K 
% =========================================================================
% =========================================================================
for trial = 1 : NumTrials
   
    fprintf('Iteration #%d\n', trial);
    %==========================================================================
    %==========================================================================
    % Randomize data: form training and testing sets
    %                             N = randomize_data(size(Y,2), round(pct_of_examples * size(Y,2)));
    colX = size(Y,2);
    [Ntest, Ntrain] = crossvalind('HoldOut', colX, pct_of_examples);
    % Define training and testing set
    Xtrain = X(:,Ntrain);Ytrain = Y(:,Ntrain);
    Xtest = X(:,Ntest); Ytest = Y(:,Ntest);
    
    % =========================================================================
    % =========================================================================
    % =========================================================================
    % =========================================================================
    
    %         OP-RVFL
    [Wout  , WB    ] = Train_OP_RVFL_Neural_Network_12_May_16( ...
    Xtrain, ...
    Ytrain , ...
    order_of_expansion , ...
    beta , ...
    polynomial_type , ...
    num_hidden ,...
    activation_function,...
    bias_flag,...
    direct_link_flag);
    %     simulate RVFLPINV
    % test
    [Ytestoprvflpinv(trial,:) ] = Simulate_OP_RVFL_Neural_Network_12_May_16( ...
    Xtest , ...
    Wout, ...
    WB, ...
    order_of_expansion , ...
    polynomial_type , ...
    activation_function,...
    direct_link_flag);
    %     all data
    [Yalloprvflpinv(trial,:) ] = Simulate_OP_RVFL_Neural_Network_12_May_16( ...
    X , ...
    Wout, ...
    WB, ...
    order_of_expansion , ...
    polynomial_type , ...
    activation_function,...
    direct_link_flag);
    %     training data
    [Ytrainoprvflpinv(trial,:) ] = Simulate_OP_RVFL_Neural_Network_12_May_16( ...
    Xtrain , ...
    Wout, ...
    WB, ...
    order_of_expansion , ...
    polynomial_type , ...
    activation_function,...
    direct_link_flag);
    % =========================================================================
    % =========================================================================
%     Gather RMSE statistics for all available, testing and training data
    
    RMSE_All_OP_RVFL(trial) = sqrt(mse(Yalloprvflpinv(trial,:)-Yall))';
    RMSE_Train_OP_RVFL(trial) = sqrt(mse(Ytrainoprvflpinv(trial,:)-Ytrain))';
    RMSE_Test_OP_RVFL(trial) = sqrt(mse(Ytestoprvflpinv(trial,:)-Ytest))';
    
    
    % =========================================================================
    % =========================================================================
end

%
figure;
subplot 311
plot(mean(Ytrainoprvflpinv),'r' ),hold on
plot(Ytrain,'-.k')
title('Training data')
legend('OP RVFL PINV','Ytrain')

subplot 312
plot(mean(Ytestoprvflpinv),'r' ),hold on
plot(Ytest,'-.k')
legend('OP RVFL PINV','Ytest')
title('Testing data')
subplot 313
plot(mean(Yalloprvflpinv),'r' ),hold on
plot(Yall,'-.k')
legend('OP RVFL PINV','Y')
title('All data')

% ==
fprintf(' +====+ ')
fprintf(' OP RVFL ')
fprintf('mean std min max kurtosis skewness')
RMS_All = [mean(RMSE_All_OP_RVFL) std(RMSE_All_OP_RVFL) min(RMSE_All_OP_RVFL) max(RMSE_All_OP_RVFL) kurtosis(RMSE_All_OP_RVFL) skewness(RMSE_All_OP_RVFL)]
RMS_Train = [mean(RMSE_Train_OP_RVFL) std(RMSE_Train_OP_RVFL) min(RMSE_Train_OP_RVFL) max(RMSE_Train_OP_RVFL) kurtosis(RMSE_Train_OP_RVFL) skewness(RMSE_Train_OP_RVFL)]
RMS_Test = [mean(RMSE_Test_OP_RVFL) std(RMSE_Test_OP_RVFL) min(RMSE_Test_OP_RVFL) max(RMSE_Test_OP_RVFL) kurtosis(RMSE_Test_OP_RVFL) skewness(RMSE_Test_OP_RVFL)]

