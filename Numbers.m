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
	numGrid = [];
	
	figureSetup();
	newGame();
	
	% Handles mouse clicks within the figure window.
	function [] = click(~,~)
		
	end
	
<<<<<<< HEAD
=======
	% Handles mouse clicks on numbers
	function [] = clickNum(~,~,row,col)
% 		numGrid(row,col).BackgroundColor = rand(1,3);
	end
	
	
>>>>>>> firstCode
	% 'New' button callback
	function [] = newGame(~,~)
		cla
		cols = str2num(colsInp.String);
		
<<<<<<< HEAD
		str = cell(ceil(length(seedInp.String)/cols),1);
		for i = 1:ceil(length(seedInp.String)/cols)
			str{i,1} = sprintf(' %c',seedInp.String(1 + cols*(i - 1):min([length(seedInp.String), cols*i])));
		end
		
		numGrid = text(0,0.5,str,'FontName','fixedwidth','FontUnits','normalized','FontSize',0.1);
		if numGrid.Extent(3) > 1
% 			numGrid.FontSize = 
		end
		% add numbers
		% draw lines
=======
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
>>>>>>> firstCode
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
<<<<<<< HEAD
			'String','12345678911112131415161718',...
=======
			'String','1234567891112131415161718',...
>>>>>>> firstCode
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
	end
end


























