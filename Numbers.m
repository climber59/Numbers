%{
===================================== new features

===================================== known bugs

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
	
	figureSetup();
	newGame();
	
	
	% removes extra blank spaces
	function [] = condense(~,~)
		cols = size(numGrid,2);
		r = 1;
		c = 1;
		while r <= size(numGrid,1)
			while isa(numGrid(r,c),'matlab.graphics.primitive.Text') && ~isempty(numGrid(r,c))%will need something to keep in bounds
				c = c + 1;
				if c > cols
					r = r + 1;
					c = 1;
				end
			end
			r1 = r;
			c1 = c;
			count = 1;
			while isa(numGrid(r,c),'matlab.graphics.primitive.Text') && isempty(numGrid(r,c)) && count < cols
				count = count + 1;
				c = c + 1;
				if c > cols
					r = r + 1;
					c = 1;
				end
			end
			if count == cols
% 				numGrid(
			end
		end
	end
	
	function [] = check(~,~)
		[r,c] = size(numGrid);
		cols = c;
		while (isa(numGrid(r,c),'matlab.graphics.GraphicsPlaceholder') || isempty(numGrid(r,c).String)) && ~(r==1 && c==1)
			c = c - 1;
			if c == 0
				r = r - 1;
				c = cols;
			end
		end
		ng = numGrid';
		str = [ng(1:((r-1)*cols + c)).String];
		
		for i = 1:length(str)
			c = c + 1;
			if c > cols
				r = r + 1;
				c = 1;
			end
			numGrid(r,c) = text(c-0.85,r,str(i),'FontName','fixedwidth','FontUnits','normalized','FontSize',0.1,'ButtonDownFcn',{@clickNum,r,c});
		end
% 		axis([0 size(numGrid,2), 0 size(numGrid,2)*diff(ax.YLim)/diff(ax.XLim)])
% 		isa(numGrid(3,7),'matlab.graphics.primitive.Text')
% 		isa(numGrid(3,8),'matlab.graphics.primitive.Text')
	end
	
	% Handles mouse clicks within the figure window.
	function [] = click(~,~)
		
	end
	
	% Handles mouse clicks on numbers
	function [] = clickNum(~,~,row,col)
		sel.UserData.first = ~sel.UserData.first;
		
		if sel.UserData.first % picking first num
			sel.Visible = 'on';
			sel.XData = col - [1 0 0 1];
			sel.YData = row - 0.5*[1 1 -1 -1];
			sel.UserData.rc = [row,col];
		else % picking second num
			sel.Visible = 'off';
			if canMatch([row,col],sel.UserData.rc)
				numGrid(row,col).String = '';
				numGrid(sel.UserData.rc(1),sel.UserData.rc(2)).String = '';
			else
				
			end
		end
		
		
		
		
% 		selection.UserData
% 		numGrid(row,col).BackgroundColor = rand(1,3);
	end
	
	function [blah] = canMatch(a, b)
		blah = false;
		if a(2) == b(2) % same column
			top = max(a(1),b(1)); % higher row
			bot = min(a(1),b(1)); % lower row
			i = bot + 1;
			while i < top && isempty(numGrid(i,a(2)).String)
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
			while (i < B(2,2) || j < B(2,1)) && isempty(numGrid(j,i).String)
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
			numGrid(r,c) = text(c-0.85,r,seedInp.String(i),'FontName','fixedwidth','FontUnits','normalized','FontSize',0.1,'ButtonDownFcn',{@clickNum,r,c});
		end
		axis([0 cols, 0 cols*diff(ax.YLim)/diff(ax.XLim)])
		
		sel = patch(...
			'Parent',ax,...
			'EdgeColor', [0 1 0],...
			'FaceAlpha', 0,...
			'Visible','off');
		sel.UserData.first = false;
	end
	
	%
	function [] = axesScroll(~,~)
		
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
			'Callback',{@axesScroll});
		
		
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
	end
end


























