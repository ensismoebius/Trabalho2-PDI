function [maskedRgbImage, mask] = generateMaskedImage(image)
	%% Apply low and high pass filters
	[originalGrayed, blurred] = applyLowOrHighPass(image, 60, 0);
	[~, hiFreqImage] = applyLowOrHighPass(image, 1, 1);
	
	%% Creating image mask
	mask = generateMask(hiFreqImage, blurred);
	
	%% Final result
	maskedRgbImage = bsxfun(@times, originalGrayed, cast(mask, 'like', originalGrayed));
	
	%% Subroutines definitions
	function [mask] = generateMask(hiFreqImage, blurred)
			imSubtration = hiFreqImage - blurred;
			
			% Binarize with Otsu
			binarized = imbinarize(imSubtration, graythresh(imSubtration));
			
			% Morphologiacal operations for noise removal
			se = strel ('disk',3);
			eroded = imerode(binarized,se);
			se = strel('disk',5);
			expanded = im2bw(imdilate(eroded, se), 0.5);
			
			% Morphological operations for holes removal
			mask = imfill(expanded,'holes');
	end
	
	function [result] = lowOrHighPass(image, radius, sizex, sizey, highpass)
		%% Builds low or high pass filters
		[x,y]=meshgrid(-sizey/2:sizey/2-1, -sizex/2:sizex/2-1);
		z=sqrt(x.^2+y.^2);
		
		if(highpass == 1)
			c=z>=radius;
		else
			c=z<=radius;
		end

		%% Apply filter
		af=fftshift(fft2(image));
		af1=af.*c;
		result=ifft2(ifftshift(af1));

		%% Normalize result
		f1=abs(result);
		fm=max(result(:));
		result=f1/fm;
		
		%% Convert back to gray scale image
		result=uint8(result*255);
	end
	
	function [grayedOriginal, result] = applyLowOrHighPass(image, radius, highpass)
		grayedOriginal=rgb2gray(image);
		
		imgSize = size(grayedOriginal);
		sizex = imgSize(1);
		sizey = imgSize(2);
		
		[result] = lowOrHighPass(grayedOriginal, radius, sizex, sizey, highpass);
	end
end