a = board;
a.name = a.named;
b1 = brain;
b2 = brain;
b1.weightsI = 'wi1.csv';
b1.weightsH = 'wh1.csv';
b1.weightsO = 'wo1.csv';
b1.biases = 'b1.csv';
b2.weightsI = 'wi2.csv';
b2.weightsH = 'wh2.csv';
b2.weightsO = 'wo2.csv';
b2.biases = 'b2.csv';
b1 = b1.prep(a.M);
b2 = b2.prep(a.M');
numiterations = 10^3;
gamesplayed = 0;
score = a.score;
b1data = zeros(9,numel(a.M)+1);
b2data = zeros(9,numel(a.M)+1);
turn = 1;
while gamesplayed<numiterations
    while score == a.score
        
        
            [b1,choice] = b1.decide(a.M);
            [a,empty] = a.fillc(choice,-1);
        while empty == 0
            [b1,choice] = b1.newdecision;
            [a,empty] = a.fillc(choice,-1);
        end
        M = b1.vectorize(a.M);
        b1data(turn,1) = choice;
        b1data(turn,2:end) = M;

        
         [b2,choice] = b2.decide(a.M);
            [a,empty] = a.fillc(choice,1);
        while empty == 0
            [b2,choice] = b2.newdecision;
            [a,empty] = a.fillc(choice,1);
        end
        M = b2.vectorize(a.M);
        b2data(turn,1) = choice;
        b2data(turn,2:end) = M;

            turn = turn+1;
    end
    for i = 1:turn-1
                 b1 = b1.backProp(b1data(i,2:end),b1data(i,1),-1*a.winner);
                 b2 = b2.backProp(b1data(i,2:end),b1data(i,1),a.winner);
    end

    turn = 1;
    score = a.score;
gamesplayed = gamesplayed +1
end
    b1.save
    b2.save
