function runExample(image)
	%% Generate masked image
	[maskedRgbImage, mask] = generateMaskedImage(image);

	%% Shows results
	subplot(2,2,1),imshow(image);
	subplot(2,2,3),imshow(maskedRgbImage);
	subplot(2,2,4),imshow(mask);
end