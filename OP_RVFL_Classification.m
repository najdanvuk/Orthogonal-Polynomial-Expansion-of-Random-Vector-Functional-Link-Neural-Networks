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
% orthogonal polynomial) to output layer for classification.
% Just uncomment the dataset you would like to use.
% =========================================================================
% =========================================================================
% Note: you need to add all folders to path (select folder, right click=> add folders...)
% =========================================================================
clc,clear, close all
% rng('shuffle')
% rng('default')
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
beta = .0100;          % RIDGE REGRESSION PARAMETER
num_hidden = 5;          % NUMBER OF NEURONS IN THE HIDDEN LAYER
NumTrials = 20;          % NUMBER OF TRIALS
% =========================================================================
% Important to note: order of expansion, beta, num_hidden should be
% determined with crossvalidation. The same goes for activation function
% and polynomial type if one models particular problem with OP RFVL NN.
% =========================================================================
fprintf('OP RVFL NN for Classification: # of Trials:%d\n ', NumTrials)
% =========================================================================
% =========================================================================
%                           T E S T   S E T S
%==========================================================================
%==========================================================================
% Iris
X = csvread('IrisX.csv')';
Y = csvread('IrisY.csv')';
% =========================================================================
% =========================================================================
% %     Wine
% wine_data;
% Y = winedata(:,1)';
% X = winedata(:,2:end)';
% y = zeros(numel(unique(Y)),length(Y));
% ff=unique(Y);
% for k = 1 : numel(unique(Y))
%     [a,index]=find(ff(k)==Y);
%     y(k,index)=ones(1,numel(index));
% end
% Y = y;
% clear wine_data
%==========================================================================
%==========================================================================
% Image segmentation
% load segment1.dat
% X = segment1(1:end,1:size(segment1,2)-1)';
% Y = segment1(1:end,size(segment1,2))';
% y = zeros(numel(unique(Y)),length(Y));
% ff=unique(Y);
% for k = 1 : numel(unique(Y))
%     [a,index]=find(ff(k)==Y);
%     y(k,index)=ones(1,numel(index));
% end
% Y = y;
% clear segment1
%==========================================================================
%==========================================================================
% Glass
% X = glass_data(:,2:end-1)';
% Y = glass_data(:,end)';
% y = zeros(numel(unique(Y)),length(Y));
% ff=unique(Y);
% for k = 1 : numel(unique(Y))
%     [a,index]=find(ff(k)==Y);
%     y(k,index)=ones(1,numel(index));
% end
% Y = y;
% clear glass_data
%==========================================================================
%==========================================================================
% Pima
% X = pima_data(:,1:end-1)';
% Y = pima_data(:,end)';
% y = zeros(numel(unique(Y)),length(Y));
% ff=unique(Y);
% for k = 1 : numel(unique(Y))
%     [a,index]=find(ff(k)==Y);
%     y(k,index)=ones(1,numel(index));
% end
% Y = y;
% clear pima_data
%==========================================================================
%==========================================================================
% Wisconsin
% X = wisconsin_breast_cancer_data(:,2:end-1)';
% Y = wisconsin_breast_cancer_data(:,end)';
% y = zeros(numel(unique(Y)),length(Y));
% ff=unique(Y);
% for k = 1 : numel(unique(Y))
%     [a,index]=find(ff(k)==Y);
%     y(k,index)=ones(1,numel(index));
% end
% Y = y;
% clear wisconsin_breast_cancer_data
%==========================================================================
%==========================================================================
Sonar
X = sonar_data(:,2:end-1)';
Y = sonar_data(:,end)';
y = zeros(numel(unique(Y)),length(Y));
ff=unique(Y);
for k = 1 : numel(unique(Y))
    [a,index]=find(ff(k)==Y);
    y(k,index)=ones(1,numel(index));
end
Y = y;
clear sonar_data
%==========================================================================
%==========================================================================
% % scale data

X = (X-min(X(:)))./(max(X(:))-min(X(:)));   % to [0,1]
Y = (Y-min(Y(:)))./(max(Y(:))-min(Y(:)));   % to[0,1]

Xall = X ; Yall = Y;
%==========================================================================
%==========================================================================


for trial = 1 : NumTrials
    
    fprintf('Trial #%d\n', trial);
    
    %==========================================================================
    %==========================================================================
    % Randomize data for training
    N = randomize_data(size(Y,2), round(pct_of_examples * size(Y,2)));
    % Define training and testing set
    Xtrain = X(:,N);Ytrain = Y(:,N);
    Ntest = setdiff(1:size(Y,2),N);
    Xtest = X(:,Ntest); Ytest = Y(:,Ntest);   
    
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
    [Ytestoprvflpinv(:,:,trial) ] = Simulate_OP_RVFL_Neural_Network_12_May_16( ...
        Xtest , ...
        Wout, ...
        WB, ...
        order_of_expansion , ...
        polynomial_type , ...
        activation_function,...
        direct_link_flag);
    %     all data
    [Yalloprvflpinv(:,:,trial) ] = Simulate_OP_RVFL_Neural_Network_12_May_16( ...
        Xall , ...
        Wout, ...
        WB, ...
        order_of_expansion , ...
        polynomial_type , ...
        activation_function,...
        direct_link_flag);
    
    %     training data
    [Ytrainoprvflpinv(:,:,trial) ] = Simulate_OP_RVFL_Neural_Network_12_May_16( ...
        Xtrain , ...
        Wout, ...
        WB, ...
        order_of_expansion , ...
        polynomial_type , ...
        activation_function,...
        direct_link_flag);
    % =========================================================================
    % =========================================================================
    
    % calculate errors staitistics
    %     for testing data
    Pct_test(trial,:) = accuracy_of_classifier(Ytestoprvflpinv(:,:,trial), Ytest);
    Pct_all(trial,:) = accuracy_of_classifier(Yalloprvflpinv(:,:,trial), Y);
    Pct_train(trial,:) = accuracy_of_classifier(Ytrainoprvflpinv(:,:,trial), Ytrain);
    
end

fprintf('test data ')
fprintf(' || mean_Pct_test std_Pct_test')
Error_Pct_Test = [mean(Pct_test) std(Pct_test)]
fprintf('all data')
fprintf(' || mean_Pct_all std_Pct_all')
Error_Pct = [mean(Pct_all) std(Pct_all)]
% =========================================================================
% =========================================================================
% Let us see confusion matrix for average performance of network
plotconfusion(Ytest,mean(Ytestoprvflpinv,3))
% Imoprtant to note: confusion matrix is calculated using average
% performance of OP RVFL network. To really see average confusion matrix,
% it should have been calculated after each trial and than averaged over
% all trials. 
% AVG_ACCURACY = accuracy_of_classifier(mean(Ytestoprvflpinv,3),Ytest)
% =========================================================================
% =========================================================================
% Finally, fpr, tpr, and auroc
figure
plotroc(Ytest,mean(Ytestoprvflpinv,3)),title('ROC for All Classes')
[tpr,fpr,thresholds] = roc(Ytest,mean(Ytestoprvflpinv,3));

% for ii = 1 : size(Y,1)
%     figure(100+ii)
%     plot(fpr{ii},tpr{ii},'r', 'LineWidth',2)
%     title(['Class #',num2str(ii)])
%     xlabel('FPR');ylabel('TPR')
% end
GINI = NaN(1,size(Y,1));
AUROC = GINI;
for jj = 1 : size(Y,1)
    SUM = 0;
    TPR = tpr{jj} ;     FPR = fpr{jj};
    for ii = 2 : length(fpr{1})
        SUM = SUM + (TPR(ii)- TPR(ii-1)) * (FPR(ii)+ FPR(ii-1)) ;
    end
    GINI(jj) = 1 - SUM ;  AUROC(jj) = (GINI(jj) + 1)/2;
end
fprintf('GINI & AUROC per class')
Gini = GINI
Auroc = AUROC
% =========================================================================
% Now, it should be stressed that classification is complex problem and it 
% cannot be solved after just one try. To really assess performance of 
% classifier one needs to choose performance metrix (for example, AUROC), 
% run multiple repetition of experiment and than use statistical hypothesis
% testing (Sign test, Wilcoxon, Friedman Rank, Freedman Aligned Rank, Quade, Sign test, etc.)
% to compare performance of one algorithm to the performance of the control algorithm.
% That procedure is not in the focus at the moment but it will be in the
% near future.
% =========================================================================
% =========================================================================
