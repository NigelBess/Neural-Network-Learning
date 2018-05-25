classdef tactoe
    properties(Access = public)
        board;
        score = [0,0];
    end
    methods (Access = public)
        function obj=fill(obj,x,player)
         
            obj.board(x) = (2*player)-3;
           obj = obj.testwin(x,player);
         
        end
        
        
        
        function obj = testwin(obj,x,player)
            if prod(obj.board(:))~=0
                obj.board = zeros(length(obj.board));
                return
            end
            column = ceil(x/length(obj.board));
            row = x - length(obj.board)*(column-1);
            rowwin = prod(obj.board(row,:) == (2*player)-3);
            columnwin = prod(obj.board(:,column) == (2*player)-3);
            diagwin = 0;
            if mod(x,2)%mod(x,2) returns 1 if even, 0 if odd.
                        %check if x is odd because only then can we be on a
                        %diagonal. 
                        %if i want this to run tictactoe games larger (or smaller) than
                        %3x3, this will have to change to:
                        %ismember(x,diag(this.M))||ismember(x,diag(rot90(this.M)))
                        %for 3x3 case mod(x,2) is significantly cheaper (I think)
                diag1 = diag(obj.board);
                diag2 = diag(rot90(obj.board));
                diagwin = prod(diag1(:) == player) || prod(diag2(:)== player);
            end
            if rowwin || columnwin || diagwin
               obj =  obj.win(player);
            end
            
        end
        
        
        function obj = win(obj,player)
            obj.score(player) = obj.score(player)+1;
            obj.board = zeros(length(obj.board));
                    end
        
   
    end
end