folds = size(Y);
folds = folds(2);

x = '[';
y = '[';
for i = 1:folds
    x =  [x,'['];
    y =  [y,'['];
    testSize = size(X{1,i});
    testSize = testSize(1);
    for ii = 1:testSize
        xCoord = X{1,i};
        yCoord = Y{1,i};
        if ii == testSize
            x =  [x, [num2str(xCoord(ii))]];
            y =  [y, [num2str(yCoord(ii))]];
        else
            x =  [x, [num2str(xCoord(ii)),',']];
            y =  [y, [num2str(yCoord(ii)),',']];
        end
    end
    if i == folds
        x =  [x,']]'];
        y =  [y,']]'];
    else
        x =  [x,'],'];
        y =  [y,'],'];
    end
end

disp(x)
disp(y)