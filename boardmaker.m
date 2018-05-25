function outvar = boardmaker(thisgame,player)
clc
global strX;
strX = boardtostring(thisgame.board);
  d = dialog('Position',[300 300 80*length(thisgame.board) 60*length(thisgame.board)],'Name','Tic Tac Toe');
for i = 1:numel(thisgame.board)
    n = ceil(i/length(thisgame.board));
    m = i-length(thisgame.board)*(n-1);
    %index = [m,n];
    string = ['output = i;thisgame = thisgame.fill(',int2str(i),',1);delete(gcf)'];
    button(i) = uicontrol('Parent',d,...
        'Style','Pushbutton',...
               'Position',[ 60*n-30, 140- 30*m, 50, 25],...
               'String',strX(i),...
               'Callback',string);
end
stopbutton = uicontrol('Parent',d,...
        'Style','Pushbutton',...
               'Position',[ 0, 20, 50, 25],...
               'String','stop',...
               'Callback','clc,running = 0;delete(gcf)');
           
           scorestring = ['You: ',int2str(thisgame.score(1)),'  Computer: ',int2str(thisgame.score(2))];
 txt1 = uicontrol('Parent',d,...
        'Style','Text',...
        'Position',[60 20 200 25],...
        'String',scorestring);
    
           waitfor(d);
  
   
end