% If you want a new kfold separation delete the "kfold.mat" file
kfoldsAmount=5;

%calling the function for reading the folder of images
maligna_images= image_reader('Roi_Recort_bisque_Maligna');
benigna_images= image_reader('Roi_Recort_bisque_Benigna');

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
[amountOfImages, columns]= size(feature_matrix); idx_bng=1;
for i=1: amountOfImages
	fprintf('Extraindo características: Fase %d de %d...\n', i, amountOfImages);
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
% The labels for final graphic
xlabels = zeros(40,1);

% The data for the final graphic
results = zeros(40,4);

% Evaluate data for each amount of descriptors from 1 up to 40
for number_of_descriptors=1: 40
	[accuracy01, accuracy02, accuracy03, average] = classificationTests(feature_matrix, label_matrix, number_of_descriptors, kfoldsAmount, amountOfImages, false);
	
	results(number_of_descriptors,:)=[accuracy01, accuracy02, accuracy03, average];
	xlabels(number_of_descriptors,:) = number_of_descriptors;
end

% Show the final results
plotFinalResults(xlabels, results);



