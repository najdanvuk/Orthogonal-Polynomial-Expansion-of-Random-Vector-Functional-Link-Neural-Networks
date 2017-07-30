% clc,clear, close all
a = .1;
b = .2;
tau = 17;
x0 = 1.2;
tmax = 2500+6;
ttrain = 1500;
ttest = 1000;

% tmax = 4500+6
% ttrain = 4000
% ttest = 4000


xseries = [];

for t = 1 : tmax
    if t == 1;
        x = x0;
    elseif t <= 17;
        x = (1-a) * xseries(t-1);
    else t > 17;
        x = (1-a)*xseries(t-1) + b * xseries(t-tau)/(1 + xseries(t-tau)^10);
    end
    xseries = [xseries x];
end
% plot(xseries,'b')


% training set
Xtrain = [];
Ytrain = [];
for kk = 19 : ttrain+18
    index_x = [kk kk-6 kk-12 kk-18];
    index_y = kk + 6;
    X = xseries(index_x);
    Y = xseries(index_y);
    Xtrain = [Xtrain X'];
    Ytrain = [Ytrain Y];

end
Xtrain;
Ytrain;
%  testing set
Xtest = [];
Ytest = [];
for kk = ttrain+1 : tmax-6
    index_x = [kk kk-6 kk-12 kk-18];
    index_y = kk + 6;
    X = xseries(index_x);
    Y = xseries(index_y);
    Xtest = [Xtest X'];
    Ytest = [Ytest Y];

end
Xtest;
Ytest;

% % guangbin huang et al.
% clc,clear,close all
% a = .2
% b = .1
% delta_t = 1
% tau = 17
% xguang = []
% tmax = 1000
% 
% for t = 1 : tmax
%     if t == 1
%         x = (a/(2+b)) * (.3/(1+.3^10))
%     elseif t <= 17
%         x = (2-b)*xguang(t-1)/3 + (a/(2+b)) * (.3/(1+.3^10))
%     else t > 17
%         x = (2-b)*xguang(t-1)/3 + (a/(2+b))*(xguang(t+delta_t-tau)/(1+xguang(t+delta_t-tau)^10) + xguang(t-tau)/(1+xguang(t-tau)^10))
%     end
%     xguang = [xguang x];
% end
% plot(xguang,'r')