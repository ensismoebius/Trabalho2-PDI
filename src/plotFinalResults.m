function plotFinalResults(xlabels, results)
	%plotFinalResults(xlabels, results)
	%  xlabels:  vector of x axes labels
	%  results:  matrix of y data
	
	% Create figure
	figure1 = figure;

	% Create axes
	axes1 = axes('Parent',figure1);
	hold(axes1,'on');
	
	% Create multiple lines using matrix input to plot
	plot1 = plot(xlabels,results,'LineWidth',2,'Parent',axes1);
	set(plot1(1),'DisplayName','Average acuracy','Marker','diamond',...
		'Color',[1 0 0]);
	set(plot1(2),'DisplayName','discrim\_analysis','LineWidth',0.5);
	set(plot1(3),'DisplayName','decision\_tree','LineStyle',':');
	set(plot1(4),'DisplayName','naive\_bayes','LineStyle','-.');
	
	% Create xlabel
	xlabel('Number of descriptors','FontSize',13.2);
	
	% Create title
	title('Accuracy of classifiers according to the number of descriptors',...
		'FontSize',13.2);
	
	% Create ylabel
	ylabel('Acuracy','FontSize',13.2);
	
	% Set the remaining axes properties
	set(axes1,'FontSize',12,'XGrid','on','YGrid','on');
	% Create legend
	legend1 = legend(axes1,'show');
	set(legend1,'FontSize',10.8);
end
