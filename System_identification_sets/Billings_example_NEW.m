% Taken from:
% Billings, Stephen A., Hua-Liang Wei, and Michael A. Balikhin. 
% "Generalized multiscale radial basis function networks." 
% Neural Networks 20.10 (2007): 1081-1094.
x0 = 4;
x1 = 6.8;
tmax = 5000;
ttrain = 2500;
X = [];
Y = [];
u = [];
for t = 1 : tmax
    u = [u .2*cos(pi*t/20)];
    if t == 1;
        x = x1;
    elseif t == 2;
        x = .25*x0 + cos(pi*x0/20)*exp(2) + u(t-1);
    else t > 2;
        x = .25*X(t-1) + cos(pi*X(t-1)/20)*exp(2-.5*(X(t-2))^2) + u(t-1);
    end
    y = x + .1 * randn;
    Y = [Y y]; X = [X x];
end
xseries = Y;

% training set
Xtrain = [];
Ytrain = [];
for kk = 3 : ttrain+2
    index_x = [kk-1 kk-2];
    xtrain = [Y(:,kk-2 : kk-1) u(kk-1)];
    ytrain = Y(kk);
    Xtrain = [Xtrain xtrain'];
    Ytrain = [Ytrain ytrain];

end
Xtrain;
Ytrain;
%  testing set
Xtest = [];
Ytest = [];
for kk = ttrain-1 : tmax
    index_x = [kk-1 kk-2];
    xtest = [Y(:,kk-2 : kk-1) u(kk-1)];
    ytest = Y(kk);
    Xtest = [Xtest xtest'];
    Ytest = [Ytest ytest];

end
Xtest;
Ytest;