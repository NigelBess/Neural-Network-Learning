g = [1;2;0.1;2;1];
g = softmax(g);
n = 1000;
X = zeros(1,n);
for i = 1: n 
    X(i) = softchoose(g);
end
dist = [1:5];
results = [0,0,0,0,0];
for i = dist;
    results(i) = sum(X == i)/numel(X);
end
bar(dist,results)