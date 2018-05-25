function [outvar,nodes] = think(X,numlayers,numnodes,weights,weights1,weightsf)
nodes = zeros(numnodes,numlayers);
nodes(:,1) = weights1 * X;
% nodes(:,1) = max(0,nodes(:,1)); %relu
for i = 2:numlayers
nodes(:,i) = weights(:,:,i)*nodes(:,i-1);
% nodes(:,i) = max(0,nodes(:,i)); %relu
end
answer = zeros(1,numel(X));
answer = weightsf*nodes(:,end);
outvar = answer;
end