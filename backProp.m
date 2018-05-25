function [start,hidden,final] = backProp(X,numlayers,numnodes,weights,weights1,weightsf,chosen,outcome)
learningRate = 0.1; %smaller makes higher accuracy, tradeoff is learning speed
final= weightsf;
hidden = weights;
start = weights1;
[lastthought,nodes] = think(X,numlayers,numnodes,weights,weights1,weightsf);
for i = 1:numnodes
final(chosen,i) = final(chosen,i)+ nodes(i,end)* learningRate*outcome; %outcome is -1(loss) or 1(win)
end
final = clamp(final);
for i = 1:numlayers    
end
end