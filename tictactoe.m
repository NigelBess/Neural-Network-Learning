
player1 = [1,0];%[playernumber,score]
player2 = [2,0];%[playernumber,score]
thisgame = tactoe;
thisgame.board = zeros(3);
dt = 0.5;
i = 1;
global running
running = 1;
while running
boardmaker(thisgame,1);
X = thisgame.board;
X = reshape (X,[9,1]);
bias = 1;
X(10) = bias;
[moveProbs,nodes] = think(X,numlayers,numnodes,weights,weights1,weightsf);
moveProbs = exp(moveProbs)./sum(exp(moveProbs));
[m,bestmove] = max(moveProbs);
while X(bestmove) ~=0 %this part makes sure you only play on an open square
moveProbs(bestmove) = 0;
[m,bestmove] = max(moveProbs);
certainty = moveProbs(bestmove)-scepticism;
dieRoll = 100000*rand;
if certainty*100000 < dieRoll
bestmove = ceil(9*rand);
end
end
    moves(i,turn) = bestmove;
thisgame=thisgame.fill(bestmove,2);
end
