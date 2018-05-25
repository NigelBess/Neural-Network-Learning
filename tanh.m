function outvar = tanh(X)
outvar = zeros(size(X));
for i = 1:numel(X)
outvar(i) = (1-exp(-2*X(i)))/(1+exp(-2*X(i)));
end
end