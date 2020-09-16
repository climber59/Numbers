%{
===================================== new features
random seeds
hints
===================================== known bugs
- can change Target mid game
===================================== Programming changes

===================================== UI changes

===================================== Rule changes

%}

%#ok<*ST2NM>
%asdf#ok<*NASGU>
% remove warning for str2num(). I use str2num() instead of str2double()
% because it evaluates strings such as '112/7'
function [] = Numbers()
	f = [];
	ax = [];
	axesSlider = [];
	colsInp = [];
	seedInp = [];
	targetInp = [];
	numGrid = [];
	sel = [];
	grayC = 0.85; % rgb value for grayed out numbers
	
	figureSetup();
	newGame();
	
	function [] = updateScroll()
		if size(numGrid,1) > diff(ax.YLim)
			axesSlider.Value = 1 - ax.YLim(1)/(size(numGrid,1) - diff(ax.YLim) + 1);
			axesSlider.SliderStep = [1/(1 + size(numGrid,1) - diff(ax.YLim)) 1];
		end
	end
	
	function [] = scroll(~,~)
		if size(numGrid,1) > diff(ax.YLim)
			ax.YLim = [0 diff(ax.YLim)] + (size(numGrid,1) - diff(ax.YLim) + 1)*(1 - axesSlider.Value);
		end
	end
	
	% removes extra blank spaces
	function [] = condense(~,~)
		[rows, cols] = size(numGrid);
		r = 1;
		c = 1;
		dels = [];
		while r <= rows && ~isa(numGrid(r,c),'matlab.graphics.GraphicsPlaceholder') && ~(r == rows && c == cols)
			while r <= rows && isa(numGrid(r,c),'matlab.graphics.primitive.Text') && numGrid(r,c).Color(1) ~= grayC
				c = c + 1;
				if c > cols
					r = r + 1;
					c = 1;
				end
			end
			r1 = r; % start of the blanks
			c1 = c;
			count = 1;
			while r <= rows && isa(numGrid(r,c),'matlab.graphics.primitive.Text') && numGrid(r,c).Color(1) == grayC && count < cols+1
				count = count + 1;
				c = c + 1;
				if c > cols
					r = r + 1;
					c = 1;
				end
			end % ends with r/c as end of blanks, or cols-th blank
			if count == cols+1 % if there is a row's worth of blanks, find their linear indices - in dels
				i = r1;
				j = c1 - 1;
				while i ~= r || j ~= c-1
					j = j + 1;
					if j > cols
						i = i + 1;
						j = 1;
					end
					dels(end+1) = sub2ind(size(numGrid),i,j);
				end
				c = c + 1;
				if c > cols
					r = r + 1;
					c = 1;
				end
			end
		end
		if ~isempty(dels) % if there are elements to remove, remove them
			delete(numGrid(dels));
			numGrid(dels) = [];
			numGrid = reshape(numGrid,rows-length(dels)/cols,cols);
			for i = 1:size(numGrid,1)
				j = 1;
				while j <= cols && isa(numGrid(i,j),'matlab.graphics.primitive.Text')
					numGrid(i,j).Position = [j-0.5, i];
					numGrid(i,j).ButtonDownFcn = {@clickNum,i,j};
					j = j + 1;
				end
			end
		end
		updateScroll()
	end
	
	function [] = check(~,~)
		[r,c] = size(numGrid);
		cols = c;
		while isa(numGrid(r,c),'matlab.graphics.GraphicsPlaceholder') && ~(r==1 && c==1) %|| isempty(numGrid(r,c).String))
			c = c - 1;
			if c == 0
				r = r - 1;
				c = cols;
			end
		end
		
		str = '';
		i = 1;
		j = 0;
		while i ~= r || j ~= c
			j = j + 1;
			if j > cols
				i = i + 1;
				j = 1;
			end
			if numGrid(i,j).Color(1) ~= grayC
				str = [str, numGrid(i,j).String];
			end
		end
		
		for i = 1:length(str)
			c = c + 1;
			if c > cols
				r = r + 1;
				c = 1;
			end
			numGrid(r,c) = newText(r,c,str(i));
		end
		updateScroll();
% 		axis([0 size(numGrid,2), 0 size(numGrid,2)*diff(ax.YLim)/diff(ax.XLim)])
% 		isa(numGrid(3,7),'matlab.graphics.primitive.Text')
% 		isa(numGrid(3,8),'matlab.graphics.primitive.Text')
	end
	
	function [t] = newText(r,c,str)
		t = text(c-0.5,r,str,'FontName','fixedwidth','FontUnits','normalized','FontSize',0.1,'HorizontalAlignment','center','ButtonDownFcn',{@clickNum,r,c});
	end
	
	% Handles mouse clicks within the figure window.
	function [] = click(~,~)
		
	end
	
	% Handles mouse clicks on numbers
	function [] = clickNum(~,~,row,col)
		
% 		[row col]
		if ~sel.UserData.first && numGrid(row,col).Color(1) ~= grayC % picking first num
			sel.UserData.first = true;
			sel.Visible = 'on';
			sel.XData = col - [0.9 0.1 0.1 0.9];
			sel.YData = row - 0.5*[1 1 -1 -1];
			sel.UserData.rc = [row,col];
		else % picking second num
			sel.UserData.first = false;
			sel.Visible = 'off';
			if canMatch([row,col],sel.UserData.rc)
				numGrid(row,col).Color = grayC * [1 1 1];
				numGrid(sel.UserData.rc(1),sel.UserData.rc(2)).Color = grayC * [1 1 1];
			else
				
			end
		end
		
		
		
		
% 		selection.UserData
% 		numGrid(row,col).BackgroundColor = rand(1,3);
	end
	
	function [blah] = canMatch(a, b)
		blah = false;
		if numGrid(a(1),a(2)).Color(1) == grayC || numGrid(b(1),b(2)).Color(1) == grayC
			return
		end
		if a(2) == b(2) % same column
			top = max(a(1),b(1)); % higher row
			bot = min(a(1),b(1)); % lower row
			i = bot + 1;
			while i < top && numGrid(i,a(2)).Color(1) == grayC %isempty(numGrid(i,a(2)).String)
				i = i + 1;				
			end
			if i ~= top % something in the way
				return
			end
		else % horizontal match
			B = sortrows([a;b]);
			i = B(1,2) + 1; % scanning column
			j = B(1,1); %scanning row
			if i > size(numGrid,2)
				i = 1;
				j = j + 1;
			end
			while (i < B(2,2) || j < B(2,1)) && numGrid(j,i).Color(1) == grayC
				i = i + 1;
				if i > size(numGrid,2)
					i = 1;
					j = j + 1;
				end
			end
			if i ~= B(2,2) || j ~= B(2,1) % something in the way
				return
			end
		end
		% if it reaches here, then the numbers are in line
		if strcmp(numGrid(a(1),a(2)).String, numGrid(b(1),b(2)).String) % same number
			blah = true;
		elseif str2num(targetInp.String) == str2num([numGrid(a(1),a(2)).String '+' numGrid(b(1),b(2)).String]) % meets target
			blah = true;
		end
	end
	
	% 'New' button callback
	function [] = newGame(~,~)
		cla
		cols = str2num(colsInp.String);
		
		numGrid = gobjects(ceil(length(seedInp.String)/cols),cols);
		r = 1;
		c = 0;
		for i = 1:length(seedInp.String)
			c = c + 1;
			if c > cols
				r = r + 1;
				c = 1;
			end
			numGrid(r,c) = newText(r,c,seedInp.String(i));%text(c-0.85,r,seedInp.String(i),'FontName','fixedwidth','FontUnits','normalized','FontSize',0.1,'ButtonDownFcn',{@clickNum,r,c});
		end
		axis([0 cols, 0 cols*diff(ax.YLim)/diff(ax.XLim)])
		updateScroll();
		
		sel = patch(...
			'Parent',ax,...
			'EdgeColor', [0 1 0],...
			'FaceAlpha', 0,...
			'Visible','off');
		sel.UserData.first = false;
	end
	
	%
	function [] = resize(~,~)
		
	end
	
	% Creates the figure and generates the majority of the UI elements
	function [] = figureSetup()
		f = figure(1);
		clf
		f.MenuBar = 'none';
		f.Name = 'Numbers';
		f.NumberTitle = 'off';
		f.WindowButtonDownFcn = @click;
		f.SizeChangedFcn = @resize;
		f.UserData = 'normal';
		f.Resize = 'on';
		f.Units = 'pixels';
		
		
		
		ax = axes('Parent',f);
		ax.Position = [0 0 0.6 1];
		ax.YDir = 'reverse';
		ax.YTick = [];
		ax.XTick = [];
		ax.XColor = [1 1 1];
		ax.YColor = [1 1 1];
		axis equal
		
		
		axesSlider = uicontrol(...
			'Parent',f,...
			'Units','normalized',...
			'Style','slider',...
			'Position',[0.00+sum(ax.Position([1 3])) 0 0.05 1],...
			'Min',0,...
			'Max',1,...
			'Value',1,...
			'SliderStep',[1 1],...
			'FontSize',12,...
			'Callback',{@scroll});
		
		
		toolPanel = uipanel(...
			'Parent',f,...
			'Units','normalized',...
			'Position',[sum(axesSlider.Position([1 3])), 0 1-sum(axesSlider.Position([1 3])) 1]);

		
		
				
		seedLbl = uicontrol(...
			'Parent',toolPanel,...
			'Style','text',...
			'Units','normalized',...
			'String','Seed:',...
			'FontUnits','normalized',...
			'FontSize',0.45,...
			'Position',[0.25 0.875 0.5 0.1]);
		seedInp = uicontrol(...
			'Parent',toolPanel,...
			'Style','edit',...
			'Units','normalized',...
			'String','1234567891112131415161718',...
			'FontUnits','normalized',...
			'FontSize',0.35,...
			'Position',[0.05 0.8 0.9 0.1]);
		
		colsLbl = uicontrol(...
			'Parent',toolPanel,...
			'Style','text',...
			'Units','normalized',...
			'String','# Columns: ',...
			'FontUnits','normalized',...
			'FontSize',0.45,...
			'Position',[0.05 0.6875 0.5 0.1]);
		colsInp = uicontrol(...
			'Parent',toolPanel,...
			'Style','edit',...
			'Units','normalized',...
			'String','9',...
			'FontUnits','normalized',...
			'FontSize',0.45,...
			'Position',[sum(colsLbl.Position([1 3])) seedInp.Position(2)-0.1 0.95-sum(colsLbl.Position([1 3])) 0.1]);
		
		targetLbl = uicontrol(...
			'Parent',toolPanel,...
			'Style','text',...
			'Units','normalized',...
			'String','Target: ',...
			'FontUnits','normalized',...
			'FontSize',0.45,...
			'Position',[0.05 0.5875 0.5 0.1]);
		targetInp = uicontrol(...
			'Parent',toolPanel,...
			'Style','edit',...
			'Units','normalized',...
			'String','10',...
			'FontUnits','normalized',...
			'FontSize',0.45,...
			'Position',[sum(targetLbl.Position([1 3])) colsInp.Position(2)-0.1 0.95-sum(targetLbl.Position([1 3])) 0.1]);
		
		ng = uicontrol(...
			'Parent',toolPanel,...
			'Units','normalized',...
			'Style','pushbutton',...
			'String','New',...
			'Callback',@newGame,...
			'Position',[0.25 0.45 0.5 0.1],...
			'FontUnits','normalized',...
			'FontSize',0.45);
		
		checkBtn = uicontrol(...
			'Parent',toolPanel,...
			'Units','normalized',...
			'Style','pushbutton',...
			'String','Check',...
			'Callback',@check,...
			'Position',[0.25 0.3 0.5 0.1],...
			'FontUnits','normalized',...
			'FontSize',0.45);
		
		condenseBtn = uicontrol(...
			'Parent',toolPanel,...
			'Units','normalized',...
			'Style','pushbutton',...
			'String','Condense',...
			'Callback',@condense,...
			'Position',[0.25 0.15 0.5 0.1],...
			'FontUnits','normalized',...
			'FontSize',0.45);
		
		debugBtn = uicontrol(...
			'Parent',toolPanel,...
			'Units','normalized',...
			'Style','pushbutton',...
			'String','debug',...
			'Callback',@debug,...
			'Position',[0.25 0.05 0.5 0.1],...
			'FontUnits','normalized',...
			'FontSize',0.45,...
			'Visible','off');
	end
	
	function [] = debug(~,~)
		numGrid
% 		numGrid(2,1)
% 		isvalid(numGrid(2,1))
% 		numGrid(isvalid(numGrid))
	end
end


























