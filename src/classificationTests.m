function [accuracy01, accuracy02, accuracy03, average] = classificationTests( feature_matrix, label_matrix, number_of_descriptors, kfoldsAmount, amountOfImages, plot )
	%CLASSIFICATIONTESTS Summary of this function goes here
	%   Detailed explanation goes here
	fprintf('Selecionando o melhor grupo de características\n');
	%calling RELIEF for ranking the most important descriptors
	[rank, weights]= relieff(feature_matrix, label_matrix, 10);
	cutted_feature_matrix= zeros(amountOfImages, number_of_descriptors);
	idx_best_descriptors=1;
	for x=1: length(feature_matrix)
		if(rank(x))<= number_of_descriptors
			cutted_feature_matrix(1:50, idx_best_descriptors)= feature_matrix(1:50, x);
			idx_best_descriptors= idx_best_descriptors+1;
		end
	end
	
	fprintf('RESULTADOS [%f descritores, %d kfolds]\n', number_of_descriptors, kfoldsAmount);
	
	% Loads the kfold separation previously generated just for the sake of reproducibility.
	% If you want a new kfold separation delete the "kfold.mat" file
	kfolds = loadOrCreateKfolds(kfoldsAmount, label_matrix);
	
	%do the classification with the cutted_feature_matrix - I can choose the classifier at the 3º parameter
	[accuracy01, matrix_of_conf01]= classification_Kfolds(cutted_feature_matrix, label_matrix, 'discrim_analysis', kfolds, kfoldsAmount, plot);
	fprintf('Acurácia média de classificação para discrim_analysis:\t %f\n', accuracy01);
	%plotting the returned confusion matrix
	if plot
		plot_result_matrix(matrix_of_conf01, {'Maligna', 'Benigna'});
	end
	
	%do the classification with the cutted_feature_matrix - I can choose the classifier at the 3º parameter
	[accuracy02, matrix_of_conf02]= classification_Kfolds(cutted_feature_matrix, label_matrix, 'decision_tree', kfolds, kfoldsAmount, plot);
	fprintf('Acurácia média de classificação para decision_tree:\t %f\n', accuracy02);
	%plotting the returned confusion matrix
	if plot
		plot_result_matrix(matrix_of_conf02, {'Maligna', 'Benigna'});
	end
	
	%do the classification with the cutted_feature_matrix - I can choose the classifier at the 3º parameter
	[accuracy03, matrix_of_conf03]= classification_Kfolds(cutted_feature_matrix, label_matrix, 'naive_bayes', kfolds, kfoldsAmount, plot);
	fprintf('Acurácia média de classificação para naive_bayes:\t %f\n', accuracy03);
	%plotting the returned confusion matrix
	if plot
		plot_result_matrix(matrix_of_conf03, {'Maligna', 'Benigna'});
	end
	
	average = (accuracy01 + accuracy02 + accuracy03)/3;
	fprintf('Acurácia média para todos os classificadores: %f\n',  average );
	
end

