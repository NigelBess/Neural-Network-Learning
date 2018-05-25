player = [1,2];
thisgame = tactoe;
global thisgame;
thisgame.board = zeros(3);
X = thisgame.board;
X = reshape (X,[9,1]);
bias = 1;
X(10) = bias;
numiterations = 10000;
iteration = 1;
numlayers = 1;
numnodes = 36;
scepticism = 0.01;
weights = zeros(numnodes,numnodes,numlayers);
for i = 1:numlayers
weights(:,:,i) = -1 + 2*rand(numnodes); %randomize all weights to start
end
weights1 = -1+2*rand(numnodes,numel(X)); %randomize initial weights
weightsf = -1+2*rand(numel(thisgame.board),numnodes); %randomize final weights
score = thisgame.score;
turn = 1;
 moves = zeros(2,9);
 Inputs = zeros(10,9,2);

while iteration <= numiterations
    while score == thisgame.score  
    for i = 1:2
        Inputs(:,turn,i) = X(:);
[moveProbs,nodes] = think(X,numlayers,numnodes,weights,weights1,weightsf);
moveProbs = exp(moveProbs)./sum(exp(moveProbs));
[m,bestmove] = max(moveProbs);
certainty = moveProbs(bestmove)-scepticism;
dieRoll = 100000*rand;
if certainty*100000 < dieRoll
bestmove = ceil(9*rand);
end
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
thisgame=thisgame.fill(bestmove,player(i));
thisgame.board;
X(1:9) = thisgame.board;
    end
    turn = turn + 1;
    end
    if score(1)<thisgame.score(1)
        winner = 1;
    elseif score(2)<thisgame.score(2)
       winner = 2;
    else
        winner = 899;
        direction = 0;
    end
    for i = 1:2
            for j = 1:9
            if i == winner
                direction = 1;
            else
                direction = -1;
            end 
            if moves(i,j)~=0
    [weights1,weights,weightsf] = backProp(Inputs(:,j,i),numlayers,numnodes,weights,weights1,weightsf,moves(i,j),direction);
            end
            end
    end
    score = thisgame.score;
    turn = 1;
    iteration = iteration + 1
end

