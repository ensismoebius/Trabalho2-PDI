function [average_accuracy, total_confusion_matrix]= classification_Kfolds(feature_vectors_matrix, label_matrix, classifier)
%validation of the classifiers using the K-FOLDS method

    k=5;
    indexes= crossvalind('kfold', label_matrix, k); %creating the indices of the folds
    accuracy_per_fold= zeros(1, k); total_confusion_matrix= zeros(2, 2); AUCroc_per_fold= zeros(1, k);
    %for ROC Curves and Average ROC Curve
    legends= cell(1, k+1);  intervals= linspace(0, 1, 100);  
    
    %beginning of the loop for folds
    for i=1: k
       idx_test= (indexes==i);
       idx_train= (indexes~=i);
       classes_of_test= label_matrix(idx_test, :); %for comparating with the response of the classifier
       
       %here I am training the classifier 
       if strcmpi(classifier, 'discrim_analysis') 
           trained_classifier= fitcdiscr(feature_vectors_matrix(idx_train, :), label_matrix(idx_train,:), 'ClassNames', {'maligna', 'benigna'});
       elseif strcmpi(classifier, 'decision_tree')
           trained_classifier= fitctree(feature_vectors_matrix(idx_train, :), label_matrix(idx_train,:), 'ClassNames', {'maligna', 'benigna'});
       elseif strcmpi(classifier, 'naive_bayes')
           trained_classifier= fitcnb(feature_vectors_matrix(idx_train, :), label_matrix(idx_train,:), 'ClassNames', {'maligna', 'benigna'});
       else
           error('Classificador não disponível na função');
       end
              
       %now I am testing the classifier
       [predicted_class, scores]= predict(trained_classifier, feature_vectors_matrix(idx_test, :));
       accuracy_per_fold(i)= sum(cellfun(@isequal, predicted_class, classes_of_test))/length(predicted_class);
       total_confusion_matrix= total_confusion_matrix+ confusionmat(classes_of_test, predicted_class);
       
       %ROC Curve and AUC (plotting the ROC Curve for each fold and an average of the folds)
       [Xroc, Yroc, ~, AUCroc_per_fold(i)]= perfcurve(label_matrix(idx_test, :), scores(:, 1), 'maligna'); 
       plot(Xroc, Yroc, 'LineWidth', 1.5); legends{i}= sprintf('fold %d (AUC = %.2f)', i, AUCroc_per_fold(i)); hold on;
       %for getting an average of the ROC curves from each fold
       x_adj= adjust_unique_points(Xroc); %interp1 requires unique points
       if i==1
           mean_curve= (interp1(x_adj, Yroc, intervals))/k; 
       else
           mean_curve= mean_curve+ (interp1(x_adj, Yroc, intervals))/k; 
       end
       
    end %end of the loop
 
    average_accuracy= mean(accuracy_per_fold);
    average_AUC= mean(AUCroc_per_fold);

    %plotting the graph of ROC Curves
    figure(1); plot(intervals, mean_curve, 'Color', 'Black', 'LineWidth', 3.0); 
    legends{k+1}= sprintf('AUC média dos folds = %.2f', average_AUC);
    xlabel('1 - Especificidade'); ylabel('Sensibilidade'); title(strcat('Curva ROC: ', classifier)); 
    legend(legends, 'Location', 'SE');
    hold off;
    %fprintf('Teste de área: %.2f\n', trapz(intervals, mean_curve));
end