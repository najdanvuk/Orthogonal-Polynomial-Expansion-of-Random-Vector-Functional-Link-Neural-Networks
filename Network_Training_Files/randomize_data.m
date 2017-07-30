function N = randomize_data(colX, M)

% colX - # of training examples
% M - # of training examples to be used for trainin
% For example, M < colX or M = colX.

% randomly choose trainig set from available observations
if (colX == M)
    N = randperm(colX);
else
    N = [];
    while 1
        n = 1+floor(colX*(rand(1)-eps));
        if ismember(n,N)
            continue
        end
        N = [N n];
        if numel(N) == M
            break
        end
    end
end