function [average_accuracy, total_confusion_matrix]= classification_Kfolds(feature_vectors_matrix, label_matrix, classifier, kfolds, kfoldsAmount, plotIt)
	%validation of the classifiers using the K-FOLDS method
	
	accuracy_per_fold= zeros(1, kfoldsAmount); total_confusion_matrix= zeros(2, 2); AUCroc_per_fold= zeros(1, kfoldsAmount);
	%for ROC Curves and Average ROC Curve
	legends= cell(1, kfoldsAmount+1);
	intervals= linspace(0, 1, 100);
	
	if plotIt
		figure;
		hold on;
	end;
	
	%beginning of the loop for folds
	for i=1: kfoldsAmount
		idx_test= (kfolds==i);
		idx_train= (kfolds~=i);
		classes_of_test= label_matrix(idx_test, :); %for comparating with the response of the classifier
		
		%here I am training the classifier
		if strcmpi(classifier, 'discrim_analysis')
			trained_classifier= fitcdiscr(feature_vectors_matrix(idx_train, :), label_matrix(idx_train,:), 'ClassNames', {'maligna', 'benigna'}, 'discrimType', 'diagLinear');
		elseif strcmpi(classifier, 'decision_tree')
			trained_classifier= fitctree(feature_vectors_matrix(idx_train, :), label_matrix(idx_train,:), 'ClassNames', {'maligna', 'benigna'});
		elseif strcmpi(classifier, 'naive_bayes')
			trained_classifier= fitcnb(feature_vectors_matrix(idx_train, :), label_matrix(idx_train,:), 'ClassNames', {'maligna', 'benigna'}, 'DistributionNames', 'kernel');
		else
			error('Classificador n�o dispon�vel na fun��o');
		end
		
		%now I am testing the classifier
		[predicted_class, scores]= predict(trained_classifier, feature_vectors_matrix(idx_test, :));
		accuracy_per_fold(i)= sum(cellfun(@isequal, predicted_class, classes_of_test))/length(predicted_class);
		total_confusion_matrix= total_confusion_matrix+ confusionmat(classes_of_test, predicted_class);
		
		%ROC Curve and AUC (plotting the ROC Curve for each fold and an average of the folds)
		[Xroc, Yroc, ~, AUCroc_per_fold(i)]= perfcurve(label_matrix(idx_test, :), scores(:, 1), 'maligna');
		
		if plotIt
			plot(Xroc, Yroc, 'LineWidth', 1.5);
			legends{i}= sprintf('fold %d (AUC = %.2f)', i, AUCroc_per_fold(i));
		end
		
		%for getting an average of the ROC curves from each fold
		x_adj= adjust_unique_points(Xroc); %interp1 requires unique points
		if i==1
			mean_curve= (interp1(x_adj, Yroc, intervals))/kfoldsAmount;
		else
			mean_curve= mean_curve+ (interp1(x_adj, Yroc, intervals))/kfoldsAmount;
		end
		
	end %end of the loop
	
	average_accuracy= mean(accuracy_per_fold);
	average_AUC= mean(AUCroc_per_fold);
	
	%plotting the graph of ROC Curves
	if plotIt
		plot(intervals, mean_curve, 'Color', 'Black', 'LineWidth', 3.0);
		legends{i+1} = sprintf('Average folds AUC= %.2f', average_AUC);
		xlabel('1 - Specificity'); ylabel('Sensitivity');
		title(strcat('ROC curve: ', classifier),'Interpreter', 'none');
		try
			legend(legends, 'Location', 'SE');
		catch
		end
	end
	
	hold off;
end