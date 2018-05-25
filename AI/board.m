classdef board
    properties(Access = public)
        M = zeros(3); %contains board info
        score = [0,0];
        name;
        errormsg ='';
        winner = 0;
        lastchoice = 0;
        
    end
    methods (Access = public)
        
        function [this,empty] = fill(this,index,value)
             if this.M(index)~=0
                empty = 0;
                this.errormsg = 'cant go here';
                this.createUI;
                delete(gcf);
                return
             end
                this.lastchoice = index;
                
             
             this.errormsg = '';
             
             empty = 1;
            this.M(index) = value;
            if sum(sum(this.M~=0))>=length(this.M)%at least three squares must be filled
                %for a win condition to have been met. sum(sum()) because
                %sum() only adds up columns
            this = this.testwin(index,value);
            end
            
        end
        function [this,empty] = fillc(this,index,value)
            if this.M(index)~=0
                empty = 0;
                return
            end
            empty = 1;
            this.M(index) = value;
            if sum(sum(this.M~=0))>=length(this.M)%at least three squares must be filled
                %for a win condition to have been met. sum(sum()) because
                %sum() only adds up columns
            this = this.testwin(index,value);
            end
        end
        function this = testwin(this,index,value)
            %only need to check for win in the row, column and diagonal
            %that was last played.
            column = ceil(index/length(this.M)); %what column are we in
            row = index - length(this.M)*(column-1); %what row are we in
            
            rowwin = prod(this.M(row,:) == value); %boolean did we win on this row
            columnwin = prod(this.M(:,column) == value); %boolean did we win on this column
            diagwin = 0; %has to be zero before diagwin is checked. otherwise the if statement
                               %that checks for a win will fail
               if mod(index,2)%mod(x,2) returns 1 if even, 0 if odd.
                        %check if x is odd because only then can we be on a
                        %diagonal. 
                        %if i want this to run tictactoe games larger (or smaller) than
                        %3x3, this will have to change to:
                        %ismember(x,diag(this.M))||ismember(x,diag(rot90(this.M)))
                        %for 3x3 case mod(x,2) is significantly cheaper (I think)
                diag1 = diag(this.M);
                diag2 = diag(rot90(this.M));
                diagwin = prod(diag1(:) == value) || prod(diag2(:)== value);    
               end
               
                if rowwin || columnwin || diagwin
                    this =  this.win(value);
                end
                if prod(prod(this.M~=0))
                   this = this.clear
                end
        end
        
        function this = win(this,value)
            this.winner = value;
            if value == -1
            this.errormsg = 'You Win!';
            else
                this.errormsg = 'You Lose!';
            end
            player = (value+3)/2; % assuming value = -1 or 1, player will be 1 or 2
            this = this.clear(); %clear board
            this.score(player) = this.score(player)+1; %tally score
        end
        function this = clear(this)
            this.M = zeros(length(this.M));
        end
        function this = reset(this)
            this = this.clear();
            this.score = zeros(1,2);
        end
        function this = createUI (this)
            
            string = this.toString();
            d = dialog('Position',[800 300 80*length(this.M) 90*length(this.M)],...
                'Name','Tic Tac Toe');
            for i = 1:numel(this.M)
                n = ceil(i/length(this.M));
                m = i-length(this.M)*(n-1);
                action = [this.name,'=',this.name, '.fill(',int2str(i),...
                ',-1);delete(gcf);'];
                button(i) = uicontrol('Parent',d,...
               'Style','Pushbutton',...
               'Position',[ 60*n-30, 240- 30*m, 50, 25],...
               'String',string(i),...
               'Callback',action);
            end
            stopbutton = uicontrol('Parent',d,...
            'Style','Pushbutton',...
            'Position',[ 30, 20, 100, 50],...
            'String','stop',...
            'Callback','clc;delete(gcf);running = 0;');
           
            scorestring = ['You: ',int2str(this.score(1)),'  Computer: ',int2str(this.score(2))];
            txt1 = uicontrol('Parent',d,...
            'Style','Text',...
            'Position',[70 120 100 25],...
            'String',scorestring);
            
        
            txt2 = uicontrol('Parent',d,...
            'Style','Text',...            
            'Position',[70 100 100 25],...
            'String',this.errormsg);
        
            
    
            waitfor(d);
        end
        function string = toString(this)
            string = strings(length(this.M));
             for i = 1:length(this.M)
                for j = 1:length(this.M)
                 if this.M(i,j) == -1
                 string(i,j) = 'X';
                 end
                 if this.M(i,j) == 1
                    string(i,j) = 'O';
                 end
                end
              end
        end
        function string = named(this)
            string = inputname(1);
        end

    end
end