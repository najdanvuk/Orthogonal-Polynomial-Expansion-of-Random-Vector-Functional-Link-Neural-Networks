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
% orthogonal polynomial) to output layer for time series regression. You can 
% put different datasets. Lag is determined via PACF.
% Note to users: this file only tests performance of OP-RVFL NN for time
% series regression, I do not claim that this model outperforms others.
% Prior to usage of any neural network for time series I firmly believe
% that conventional methods should be tested: AR, MA, ARMA, ARIMA, SARMA, 
% NARx, etc, as well as other time series concepts such as: auto-correlations,
% heteroscedacity, lags, unit roots etc.  
% =========================================================================
% =========================================================================
% Note: you need to add all folders to path (select folder, right click=> add folders...)
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
order_of_expansion = 1;  % ORDER OF EXPANSION OF ORTHOGONAL POLYNOMIAL
beta = .000100;          % RIDGE REGRESSION PARAMETER
num_hidden = 1;          % NUMBER OF NEURONS IN THE HIDDEN LAYER
NumTrials = 10;          % NUMBER OF TRIALS 
num_lags = 20;           % NUMBER OF LAGS TO CHECK FOR PACF (FEATURE SELECTION)
% =========================================================================
% =========================================================================
% Important to note: order of expansion, beta, num_hidden should be
% determined with crossvalidation. The same goes for activation function
% and polynomial type if one models particular problem with OP RFVL NN.
% =========================================================================
% =========================================================================
fprintf('OP RVFL NN for Time series modeling: # of Trials:%d\n ', NumTrials)
% =========================================================================
% =========================================================================
%                           T E S T   S E T S
%==========================================================================
%==========================================================================
% SantaFe_laser_data_NEW_10000
%==========================================================================
%==========================================================================
% Leueven_data_10000
% =========================================================================
% =========================================================================
% load lorenz.dat
% data = lorenz(1:10000) ;
% clear lorenz
% =========================================================================
% =========================================================================
% load henon.dat
% data = henon(1:10000) ;
% clear henon
% =========================================================================
% =========================================================================
% Darwin_time_series_data
% =========================================================================
% =========================================================================
Sunspot_Time_Series_Monthly_data
% =========================================================================
% =========================================================================
% =========================================================================
% =========================================================================
% Extract features using pacf concept:
autocorr(data)
PACF = parcorr(data,num_lags); indexPACF = find(abs(PACF)>1.96/sqrt(length(data))); 

[row,col] = size(data);
true_data = data;
min_data = min(data) ; max_data = max(data);
% % normalize data to 0-1
data = (true_data - min_data) ./ (max_data - min_data);
% % normalize data to -1 - 1
% data = -1 + (data - min(data)) ./ (max(data) - min(data))*2;

X = [] ; Y = [];

for kk = indexPACF(end)+1 : row-1
    index = kk-indexPACF;
    
    X = [X data(index)];
    Y = [Y data(kk)];
end
Xall = X; Yall = Y;

%==========================================================================
%==========================================================================
Ntrain = 1:round(pct_of_examples * size(X,2));
Ntest = sort(size(X,2) - Ntrain );
Xtrain = X(:,Ntrain);Ytrain = Y(:,Ntrain);
Xtest = X; Xtest(:,Ntrain) = [];
Ytest = Y; Ytest(:,Ntrain) = [];
% =========================================================================
% =========================================================================
for trial = 1 : NumTrials
    
    fprintf('Iteration #%d\n', trial);
    
    %==========================================================================
    %==========================================================================
    % Randomize data: form training and testing sets
    N = randperm(max(Ntrain)); %randomize_data(size(Y,2), round(ne * size(Ytrain,2)));
%     or take all training data sequantialy 
%     N = 1: round(pct_of_examples * size(Y,2));

    % Define training and testing set
    Xtrain = Xtrain(:,N);Ytrain = Ytrain(:,N);   
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
    [Ytestrvflpinv(trial,:) ] = Simulate_OP_RVFL_Neural_Network_12_May_16( ...
    Xtest , ...
    Wout, ...
    WB, ...
    order_of_expansion , ...
    polynomial_type , ...
    activation_function,...
    direct_link_flag);
    %     all data
    [Yallrvflpinv(trial,:) ] = Simulate_OP_RVFL_Neural_Network_12_May_16( ...
    X , ...
    Wout, ...
    WB, ...
    order_of_expansion , ...
    polynomial_type , ...
    activation_function,...
    direct_link_flag);
    %     training data
    [Ytrainrvflpinv(trial,:) ] = Simulate_OP_RVFL_Neural_Network_12_May_16( ...
    Xtrain , ...
    Wout, ...
    WB, ...
    order_of_expansion , ...
    polynomial_type , ...
    activation_function,...
    direct_link_flag);
    % =========================================================================
    % =========================================================================

    RMSE_All_OP_RVFL(trial) = sqrt(mse(Yallrvflpinv(trial,:)-Yall))';
    RMSE_Train_OP_RVFL(trial) = sqrt(mse(Ytrainrvflpinv(trial,:)-Ytrain))';
    RMSE_Test_OP_RVFL(trial) = sqrt(mse(Ytestrvflpinv(trial,:)-Ytest))';
    
    % =========================================================================
    % =========================================================================
end

%
figure;
subplot 311
plot(mean(Ytrainrvflpinv),'r' ),hold on
plot(Ytrain,'-.k')
title('Training data')
legend('OP RVFL PINV','Ytrain')

subplot 312
plot(mean(Ytestrvflpinv),'r' ),hold on
plot(Ytest,'-.k')
legend('OP RVFL PINV','Ytest')
title('Testing data')
subplot 313
plot(mean(Yallrvflpinv),'r' ),hold on
plot(Yall,'-.k')
legend('OP RVFL PINV','Y')
title('All data')

fprintf(' +====+ ')
fprintf(' OP RVFL ')
fprintf('mean std min max kurtosis skewness')
RMS_All = [mean(RMSE_All_OP_RVFL) std(RMSE_All_OP_RVFL) min(RMSE_All_OP_RVFL) max(RMSE_All_OP_RVFL) kurtosis(RMSE_All_OP_RVFL) skewness(RMSE_All_OP_RVFL)]
RMS_Train = [mean(RMSE_Train_OP_RVFL) std(RMSE_Train_OP_RVFL) min(RMSE_Train_OP_RVFL) max(RMSE_Train_OP_RVFL) kurtosis(RMSE_Train_OP_RVFL) skewness(RMSE_Train_OP_RVFL)]
RMS_Test = [mean(RMSE_Test_OP_RVFL) std(RMSE_Test_OP_RVFL) min(RMSE_Test_OP_RVFL) max(RMSE_Test_OP_RVFL) kurtosis(RMSE_Test_OP_RVFL) skewness(RMSE_Test_OP_RVFL)]

% % =========================================================================
% % =========================================================================
% %      now, this is to see what happens when we return to the real world
% %      outside [0,1] range
% % =========================================================================
% % =========================================================================

Yallreal = min_data + (max_data-min_data)*Yall;
Ytrainreal = min_data + (max_data-min_data)*Ytrain;
Ytestreal = min_data + (max_data-min_data)*Ytest;
%
Ytestreal_mean = mean(Ytestreal );
sumYYmean = (Ytestreal - Ytestreal_mean)*(Ytestreal - Ytestreal_mean)';

for trial = 1 : NumTrials
    
    Yallrvflpinv_real(trial,:) = min_data + (max_data-min_data)*Yallrvflpinv(trial,:);
    Ytrainrvflpinv_real(trial,:) = min_data + (max_data-min_data)*Ytrainrvflpinv(trial,:);
    Ytestrvflpinv_real(trial,:) = min_data + (max_data-min_data)*Ytestrvflpinv(trial,:);
    
    RMSE_All_OP_RVFL_REAL(trial) = sqrt(mse(Yallrvflpinv_real(trial,:)-Yallreal))';
    RMSE_Train_OP_RVFL_REAL(trial) = sqrt(mse(Ytrainrvflpinv_real(trial,:)-Ytrainreal))';
    RMSE_Test_OP_RVFL_REAL(trial) = sqrt(mse(Ytestrvflpinv_real(trial,:)-Ytestreal))';
    
    
    % NMSE_sparse_test(trial) = ((Ytestreal-Ytest_flnnsparse_real(trial,:))*(Ytestreal-Ytest_flnnsparse_real(trial,:))')./ sumYYmean;
    % NMSE_blmflnn_test(trial) = ((Ytestreal-Ytest_flnnblm_real(trial,:))*(Ytestreal-Ytest_flnnblm_real(trial,:))')./ sumYYmean;
    %
%     R_2_rvflpinv_all(trial) =  1 - sum((Yallrvflpinv_real(trial,:) - Yallreal).^2)./sum((Yallreal- mean(Yallreal)).^2);
%     %
%     R_2_rvflpinv_test(trial) =  1 - sum((Ytestrvflpinv_real(trial,:) - Ytestreal).^2)./sum((Ytestreal- mean(Ytestreal)).^2);
    
end

fprintf(' +====+ ')
fprintf(' OP RVFL ')
fprintf('mean std min max kurtosis skewness')
RMS_All = [mean(RMSE_All_OP_RVFL_REAL) std(RMSE_All_OP_RVFL_REAL) min(RMSE_All_OP_RVFL_REAL) max(RMSE_All_OP_RVFL_REAL) kurtosis(RMSE_All_OP_RVFL_REAL) skewness(RMSE_All_OP_RVFL_REAL)]
RMS_Train = [mean(RMSE_Train_OP_RVFL_REAL) std(RMSE_Train_OP_RVFL_REAL) min(RMSE_Train_OP_RVFL_REAL) max(RMSE_Train_OP_RVFL_REAL) kurtosis(RMSE_Train_OP_RVFL_REAL) skewness(RMSE_Train_OP_RVFL_REAL)]
RMS_Test = [mean(RMSE_Test_OP_RVFL_REAL) std(RMSE_Test_OP_RVFL_REAL) min(RMSE_Test_OP_RVFL_REAL) max(RMSE_Test_OP_RVFL_REAL) kurtosis(RMSE_Test_OP_RVFL_REAL) skewness(RMSE_Test_OP_RVFL_REAL)]



figure;
subplot 211
plot(mean(Ytestrvflpinv_real),'r' ),hold on
plot(Ytestreal,'-.k')
legend('OPRVFL','Y')
title('Testing data')
subplot 212
plot(mean(Yallrvflpinv_real),'r' ),hold on
plot(Yallreal,'-.k')
legend('OPRVFL','Y')
title('All data')