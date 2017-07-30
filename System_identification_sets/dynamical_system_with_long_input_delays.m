% clc,clear,close all
% long input delay dynamical system
% test set
% define test controls
Y=[];utest = []
for k = 1 : 1000
    if k < 250
        test = sin(pi*k/25);
    elseif (k >= 250) && (k < 500);
        test = 1;
    elseif (k >= 500) && (k < 750);
        test = -1;
    else (k >= 750) && (k < 1000);
        test = .3 * sin(pi*k/25) + .1*sin(k*pi/32) + .6 * sin(pi*k/10);
    end
    utest = [utest test];
end
utest
% and this is system output
for k = 1 : 1000
    if k == 1
        y = 0;
    elseif k == 2
        y = .72 * Y(k-1);
    elseif k == 3
        y = .72 * Y(k-1) + .025 *Y(k-2)*utest(k-2);
    elseif k == 4
        y = .72 * Y(k-1) + .025 *Y(k-2)*utest(k-2) + .01*(utest(k-3))^2 ;
    else (k > 4)
        y = .72 * Y(k-1) + .025 *Y(k-2)*utest(k-2) + .01*(utest(k-3))^2 + .2*utest(k-4);
    end
    Y = [Y y];
end

Xtest= []
Ytest = []
test = [Y' utest']
for kk = 1 : length(test)
    if kk <= length(test)-1
        Xtest = [Xtest; test(kk,:)];
        Ytest = [Ytest; test(kk+1,1)];
    end
end

% plot(Y)
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% 
% training set
u1 = linspace(-2,2,500);
u2 = 1.05 * sin(pi*(1:500)./45);
Ytr = []
for k = 1 : 1000
    if k == 1
        y = 0;
    elseif k == 2
        y = .72 * Ytr(k-1);
    elseif k == 3
        y = .72 * Ytr(k-1) + .025 *Ytr(k-2)*u1(k-2);
    elseif k == 4
        y = .72 * Ytr(k-1) + .025 *Ytr(k-2)*u1(k-2) + .01*(u1(k-3))^2 ;
    elseif (k > 4) && (k <= 500)
        y = .72 * Ytr(k-1) + .025 *Ytr(k-2)*u1(k-2) + .01*(u1(k-3))^2 + .2*u1(k-4);
    elseif k > 500
        if k == 501
            y = .72 * Ytr(k-1);
        elseif k == 502
            y = .72 * Ytr(k-1) + .025 *Ytr(k-2)*u2(k-500-1);
        elseif k == 503
            y = .72 * Ytr(k-1) + .025 *Ytr(k-2)*u2(k-500-1) + .01*(u2(k-500-2))^2;
        elseif k >= 504
            y = .72 * Ytr(k-1) + .025 *Ytr(k-2)*u2(k-500-1) + .01*(u2(k-500-2))^2 + .2*u2(k-500-3);
        end
    end
    Ytr = [Ytr y];
end
utrain = [u1 u2]
% figure(2);plot(Ytr)
Xtrain = []
Ytrain = []
train = [Ytr' utrain']
for kk = 1 : length(train)
    if kk <= length(train)-1
        Xtrain = [Xtrain; train(kk,:)];
        Ytrain = [Ytrain; train(kk+1,1)];
    end
end
