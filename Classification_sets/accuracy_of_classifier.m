function Pct = accuracy_of_classifier(Ymodel, Ytest)

[rowYtest,colYtest] = size(Ytest);
    Err= 0;
    nCorrect_test = 0;
    for k = 1 : colYtest
        ymax = -realmax;
        yhatmax = -realmax;
        for i = 1 : rowYtest
            Err= Err+ (Ytest(i, k) - Ymodel(i, k))^2;
            if Ytest(i, k) > ymax
                ymax = Ytest(i, k);
                Class = i;
            end
            if Ymodel(i, k) > yhatmax
                yhatmax = Ymodel(i, k);
                ClassHat = i;
            end
        end
        if Class == ClassHat
            nCorrect_test = nCorrect_test + 1;
        end
    end
    %
    Err= sqrt(Err/ colYtest);
    Pct = 100 * nCorrect_test / colYtest;
    