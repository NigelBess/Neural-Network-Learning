classdef brain
    properties (Access = public)
        options;
        numlayers = 2;
        numnodes = 9;
        weightsI;
        weightsO;
        weightsH;
        biases;
        nodes;
        outnodes;
        IOsize;
        WI;
        WH;
        WO;
        B;
        maxCertainty = 0.99;
        reward = 0.1;
        learningrate = 0.01;
        
    end
    methods (Access = public)
        function this = prep(this,M)
           
        this.IOsize = numel(M);
            M = reshape (M,[this.IOsize,1]);%vectorizes input if not already vectorized
            
            if exist(this.weightsI) ~= 2 || exist(this.weightsH) ~= 2 || exist(this.weightsO) ~= 2 || exist(this.biases) ~= 2%checks if files dont exist
                this = this.createMem();    
            end
            this.weightsI
            this.weightsH
            this.WI = csvread(this.weightsI);
            this.WH = csvread(this.weightsH);
            this.WO = csvread(this.weightsO);
            this.B = csvread(this.biases);
            this = this.WHshape();

            if ~isequal(size(this.WI),[this.numnodes,this.IOsize]) || ~isequal(size(this.WH),[this.numnodes,this.numnodes,this.numlayers-1]) || ~isequal(size(this.B),[this.numnodes,this.numlayers]) || ~isequal(size(this.WO),[this.IOsize,this.numnodes])
                %^makes sure that the weight matrices are the right size
                this = this.createMem();
             this.WI = csvread(this.weightsI);
            this.WH = csvread(this.weightsH);
            this.WO = csvread(this.weightsO);
            this.B = csvread(this.biases);
            this = this.WHshape();
            end
           this.nodes = zeros(this.numnodes,this.numlayers);           
        end
        function this = createMem(this)
            this.B = 2*rand(this.numnodes,this.numlayers)-1;
            this.WI = 2*rand(this.numnodes,this.IOsize)-1;
            this.WH = 2*rand(this.numnodes,this.numnodes,this.numlayers-1)-1;
            this.WO = 2*rand(this.IOsize,this.numnodes)-1;
            this.save();
        end
        function [this,int] = decide(this,M)
            this = this.think(M);
            thought = this.outnodes;
            [certainty,int] = max(thought);            
            if certainty > this.maxCertainty
                certainty = this.maxCertainty;
                thought(int) = certainty;
            end
            int = this.softchoose(thought);
        end
        function int = softchoose(this,thought)
 
            %chooses an index of M, a softmax vector, based on its probability
            for i=2:this.IOsize
                thought(i) = thought(i)+thought(i-1);
            end
            choice = rand(1);
          
            for i = 1:size(thought)
                if choice<thought(i)
                    int = i;
                    return
                end
            end
            int = ceil(this.IOsize*rand(1));
            
        end
        function this = think(this,M)
            M = this.vectorize(M);
            this.nodes(:,1) = this.WI*M + this.B(:,1);
            this.nodes(:,1) = this.leakyRelu(this.nodes(:,1));
            for i = 2:this.numlayers
                this.nodes(:,i) = this.WH(:,:,i-1)*this.nodes(:,i-1)+this.B(:,i);
                this.nodes(:,i) = this.leakyRelu(this.nodes(:,i));
            end
            this.outnodes = zeros(this.IOsize,1);
         this.outnodes = this.WO*this.nodes(:,end);
          
         this.outnodes = softmax(this.outnodes);
         for i = 1:this.IOsize
             if M(i)~=0
                 this.outnodes(i) = 0;
             end
         end
                 end
        function vector = vectorize(this,M)
            vector = reshape (M,[this.IOsize,1]);
        end
        function this = backProp(this,M,chosen,outcome);if outcome~=0
            %outcome = 1 (win), -1 (loss), or 0 (tie)
            this = this.think(M);
            thought = this.outnodes;
            ideal = thought;
            ideal(chosen) = ideal(chosen)+outcome*this.reward;
            ideal = softmax(ideal);
            dO = this.dsoftmax(thought);
            dk = dO.*(thought-ideal);
            Oj = rot90(this.nodes(:,end));
            dW = -this.learningrate*dk*Oj;
            this.WO = this.WO + dW;
            for i = 1:this.numlayers-1
                 Oj = this.nodes(:,end-i);
                 dj = (transpose(this.WH(:,:,end-i+1))*dk).*this.dleakyRelu(Oj);
                 Oj = rot90(Oj);
                 dW = -(dj*Oj)*this.learningrate;
                 this.WH(:,:,end-i+1) = this.WH(:,:,end-i+1)+dW;
                 dB = -this.learningrate*dj;
                 this.B(:,end-1+1) = this.B(:,end-1+1)+dB;
                 dk = dj;
            end
            dO = this.dleakyRelu(this.nodes(:,1));
            Oj = this.vectorize(M);
            dj = (transpose(this.WI)*dk).*dO;
            Oj = rot90(Oj);
            dW = -(dj*Oj)*this.learningrate;
            this.WI = this.WI +dW;
            dB = -this.learningrate*dj;
            this.B(:,1) = this.B(:,1)+dB;        
           end; end
       
        function out = relu(this,x)
            out = max(0,x);
        end
        function out = leakyRelu(this,x)
            out = this.relu(x);
            for i = 1:numel(out)
            if out(i) ==0
                out(i) = 0.01*x(i);
            end
            end
        end
        function out = dleakyRelu(this,x)
            out = zeros(numel(x),1);
            for i = 1:numel(x)
            if x(i) > 0
                out(i) = 1;
             else
                out(i) = 0.01;
            end
            end
        end
        function out = drelu(this,x)
            out = zeros(numel(x),1);
            for i = 1;numel(x)
            if x(i) > 0
                out(i) = 1;
            else
                out(i) = 0;
            end
            end
        end
        function out = dsoftmax(this,x)
            out = softmax(x);
        end
        function this = WHshape(this)
            s = size(this.WH);
            M =  this.WH;
            this.WH = zeros(s(1),s(1),this.numlayers-1);
            for i = 1:this.numlayers-1
                this.WH(:,:,i) = M(:,s(1)*(i-1)+1:s(1)*i);
            end
        end
        function this = save(this)
            csvwrite(this.biases,this.B)
            csvwrite(this.weightsI,this.WI);
            csvwrite(this.weightsH,this.WH);
            csvwrite(this.weightsO,this.WO);
        end
        function [this,choice] = newdecision(this)
            thought =  this.outnodes;
        [certainty,index] = max(thought);
        this.outnodes(index) = 0;
        thought = softmax(this.outnodes);
        if certainty > this.maxCertainty
                certainty = this.maxCertainty;
                thought(index) = certainty;
        end
        choice = this.softchoose(this.outnodes);
        end
        function this = clear(this)
            choice = menu('are you sure? Deleting files can not be undone','fuckyea delete em','nope')
            if choice==1
                wi = this.weightsI;
                wh = this.weightsH;                    
                wo = this.weightsO;
                b = this.biases;
        delete (wi)
        delete (wh)
        delete (wo)
        delete (b)
            end
        end
    
     end
end