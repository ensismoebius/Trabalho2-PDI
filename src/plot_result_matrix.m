function []= plot_result_matrix(input_matrix, input_labels)
	
	[rows, columns]= size(input_matrix);
	figure; imagesc(input_matrix); title('Confusion Matrix'); xlabel('Predicted Class'); ylabel('True Class');
	set(gca, 'XTick', 1:rows, 'XTickLabel', input_labels, 'YTick', 1:columns, 'YTickLabel', input_labels);
	for ii= 1: rows
		for jj=1: columns
			text(jj, ii, num2str(input_matrix(ii, jj)), 'Color', 'white', 'FontSize', 14);
		end
	end
	
	my_map= [0 0 0.3
		0 0 0.4
		0 0 0.5
		0 0 0.6
		0 0 0.7
		0 0 0.8
		0 0 0.9
		0 0 1.0];
	colormap(my_map);
	
end