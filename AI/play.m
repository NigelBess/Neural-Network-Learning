a = board;
a.name = a.named;
b = brain;
b = b.prep(a.M,'wi1.csv','wh1.csv','wo1.csv','b1.csv');
global running
running = 1;
score = a.score;
turn = 1;
braindata = zeros(18,numel(a.M)+1);
while running
    while score == a.score
        a.createUI;
        [b,choice] = b.decide(a.M);
        [a,empty] = a.fillc(choice,1);
        while empty == 0
            [b,choice] = b.newdecision;
            [a,empty] = a.fillc(choice,1);
        end
        braindata(2*turn-1,1) = choice;
        braindata(2*turn-1,2:end) = b.vectorize(a.M);
        braindata(2*turn,1) = a.lastchoice;
        braindata(2*turn,2:end) = -1*b.vectorize(a.M);
        turn = turn+1;
        score = a.score;
    end
    for i = 1:turn-1
        b = b.backProp(braindata(2*i-1,2:end),braindata(2*i-1,1),a.winner);
        b = b.backProp(braindata(2*i,2:end),braindata(2*i,1),-1*a.winner);
    end
    b.save
end