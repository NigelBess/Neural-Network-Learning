function strX = boardtostring(X)
strX = strings(length(X));
for i = 1:length(X)
    for j = 1:length(X)
        if X(i,j) == 1
            strX(i,j) = 'X';
        end
        if X(i,j) == -1
            strX(i,j) = 'O';
        end
    end
end
end