Box_Jenkins
X = Box_Jenkins_data(:,1);
Y = Box_Jenkins_data(:,2);
clear Box_Jenkins_data

Xt = [];
Yt = [];

ttrain = 200
settle_point = 50

for kk = 7 : numel(Y)    
        utrain = [X(kk-1) X(kk-2) X(kk-3) X(kk-4) X(kk-5) X(kk-6)]';
        ytrain = [Y(kk-1) Y(kk-2) Y(kk-3) Y(kk-4)]';
        Xt = [Xt  [ytrain ; utrain]];
        Yt = [Yt Y(kk)];
end

Xreal = Xt;
Yreal = Yt;
% figure(1);plot(Yt);
% figure(2);plot(Yreal,'r')


Xtrain = Xt(:,settle_point+1: ttrain);
Ytrain = Yt(settle_point+1: ttrain);
Xtest = Xt(:,ttrain+1: end);
Ytest = Yt(ttrain+1: end);
xseries = Yt;
% =========================================================================
% =========================================================================

% % simulate gross error noise model as first order Markov chain
% % define state
% delta = .05;
% DoF = 10;
% noiseVar1 = 1;
% noiseVar2 = 10;
% state  = [0;...         % casual noise :)
%             1] ;         % outlier 
% % define transition probability
% P = [1-delta delta;... 
%     delta 1-delta ];
% 
% % define initial probabilty of state
% pi0 = rand(1,2);
% pi0 = pi0./sum(pi0);
% 
% [chain,state] = simulate_markov(state,P,pi0,numel(Y));
% % 
% minus_plus = [ones(1,numel(Y)/2) -ones(1,numel(Y)/2) ];
% minus_plus = minus_plus(randperm(size(minus_plus,2)));
% 
% outliers = [];
% Casual_noise = [];
% for k = 1 : numel(Y)-7
%     if chain(k) == 1
%         casual_noise = iwishrnd(1,DoF); %randn(); %;
%         Yt(k) = Yt(k) + minus_plus(k) * sqrt(casual_noise) ;
%         Casual_noise = [Casual_noise ; k Yt(k)];%casual_noise ];
%     else 
%         outlier = sqrt(noiseVar2) * randn();
%         Yt(k) = Yt(k) + outlier;
%         outliers = [outliers; k Yt(k)];%outlier]];
%     end
% %     Yt = [Yt Ytr(k)]; 
% %     Ytrain = [Ytrain; train(kk+1,1)];
% end

figure(313);
% plot(Yt,'r');hold on;
plot(Yreal)
figure(17)
plot(Ytrain,'r'),hold on;
plot(Ytest,'b')