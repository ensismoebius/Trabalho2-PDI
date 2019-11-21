%calling the function for reading the folder of images
maligna_images= image_reader('.\samples\Roi_Recort_bisque_Maligna');
benigna_images= image_reader('.\samples\Roi_Recort_bisque_Benigna');

%filtering the images (choose % of the total) -- 1 == all images
maligna_images= filtering_images(maligna_images, 1);
benigna_images= filtering_images(benigna_images, 1);

%here I have two groups for comparison - GRAY SCALE ORIGINAL IMAGES and SEGMENTED IMAGES (is segmentation necessary?)
gray_maligna_images= cell(1, length(maligna_images)); segmented_maligna_images= cell(1, length(maligna_images));
gray_benigna_images= cell(1, length(benigna_images)); segmented_benigna_images= cell(1, length(benigna_images));
for i=1: length(benigna_images)
    if i<25
       gray_maligna_images{i}= rgb2gray(maligna_images{i});
       segmented_maligna_images{i}= imsubtract(gray_maligna_images{i}, uint8(imbinarize(gray_maligna_images{i})));
    end
    gray_benigna_images{i}= rgb2gray(benigna_images{i});
    segmented_benigna_images{i}= imsubtract(gray_benigna_images{i}, uint8(imbinarize(gray_benigna_images{i})));
end   

%matrix of labels, for Relief and Classifiers
label_matrix= cell(50,1);

%matrix of caracteristics of all images - the next two lines are just for allocation
formatted_feature_vector= cell2mat(feature_extractor(gray_maligna_images{1})); %just for getting the length
feature_matrix= zeros(length(maligna_images)+length(benigna_images), length(formatted_feature_vector));
[rows, columns]= size(feature_matrix); idx_bng=1;
for i=1: rows
    if i < (length(maligna_images)+1) %here I can choose if I want to extract from original gray images or segmented ones
        feature_vector= feature_extractor(segmented_maligna_images{i});% <-
        formatted_feature_vector= cell2mat(feature_vector); 
        feature_matrix(i, 1:length(feature_matrix))= formatted_feature_vector;
        label_matrix{i}= 'maligna';
    else
        feature_vector= feature_extractor(segmented_benigna_images{idx_bng});% <-
        formatted_feature_vector= cell2mat(feature_vector); 
        feature_matrix(i, 1:length(feature_matrix))= formatted_feature_vector;
        idx_bng= idx_bng+1;
        label_matrix{i}= 'benigna';
    end 
end

%calling RELIEF for ranking the most important descriptors
[rank, weights]= relieff(feature_matrix, label_matrix, 10);
%selecting the first X better descriptors
number_of_descriptors=30; 
cutted_feature_matrix= zeros(rows, number_of_descriptors);
idx_best_descriptors=1;
for x=1: length(feature_matrix)
    if(rank(x))<= number_of_descriptors
        cutted_feature_matrix(1:50, idx_best_descriptors)= feature_matrix(1:50, x);
        idx_best_descriptors= idx_best_descriptors+1;
    end
end    

%do the classification with the cutted_feature_matrix - I can choose the classifier at the 3º parameter
[accuracy, matrix_of_conf]= classification_Kfolds(cutted_feature_matrix, label_matrix, 'decision_tree');
disp('FINALIZADO - RESULTADOS----------------------------------------------');
fprintf('Acurácia média de classificação: %f\n', accuracy);
%plotting the returned confusion matrix 
plot_result_matrix(matrix_of_conf, {'Maligna', 'Benigna'});
