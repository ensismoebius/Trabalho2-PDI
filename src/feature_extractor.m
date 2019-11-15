function vector= feature_extractor(input_img) %this function receives a grayscale img as input and returns a feature vector

    %FIRST ORDER MEASURES
        vector{1}= mean2(input_img);  %average
        vector{2}= (std2(input_img))^2; %variance is the square of the standard deviation
    %SECOND ORDER MEASURES -> derived from gray level co-ocurrence matrix (glcm)
        glcm= graycomatrix(input_img);
        vector{3}= graycoprops(glcm, 'energy'); vector{3}= struct2array(vector{3}); %energy from glcm
        vector{4}= entropy(glcm); %entropy from glcm
        vector{5}= graycoprops(glcm, 'contrast'); vector{5}= struct2array(vector{5});%constrast from glcm
        vector{6}= (std2(glcm))^2; %heterogeneity is equals to the variance (square of standard deviation)
        vector{7}= graycoprops(glcm, 'correlation'); vector{7}= struct2array(vector{7}); %correlation from glcm
        vector{8}= graycoprops(glcm, 'homogeneity'); vector{8}= struct2array(vector{8});%homegenity from glcm
    %FOURIER DESCRIPTOR -> extracted from the binary image
        vector{9}= fourier_descriptors(input_img);
    %LOCAL BINARY PATTERN (LBP)
        vector{10}= double(extractLBPFeatures(input_img));  disp('Extraindo características...');
    %FRACTAL DIMENSION -> extracted from the binary image
        vector{11}= fract_dim_boxcounting(input_img);
end