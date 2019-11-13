function vector= fourier_descriptors(input_img) %this function receives an img for calculating Fourier descriptors (FD)
%the FD are calculated catching just the low frequencies of the the binary img DFT
%if I catch just the coeficients below certain frequency I can reconstruct the signal with a little smooth
%this happens because the essential characteristics of an image are in the low frequencies
%so, the objective is catch just the frequencies in the middle of the spectrum (after the shift)
%figure(10); imshow(input_img); title('Imagem Original');


coefficients= fft2(input_img); %dft of the image
shift_coef= fftshift(coefficients); %shift of the DFT
[rows, columns]= size(coefficients);

%I want just the low frequencies, the essential information of the image -> in the center of the spectrum (10%)
index_lowrows= round(rows*0.10);
index_lowcolumns= round(columns*0.10);
low_coef= cell(1, 1);
low_coef{1}= shift_coef(((rows/2)-(index_lowrows/2)): ((rows/2)+(index_lowrows/2)), ((columns/2)-(index_lowcolumns/2)) : ((columns/2)+(index_lowcolumns/2)));

%showing the reconstruction just with the low frequencies (descriptors)
%figure(1); imshow(log(abs(ifft2(low_coef{1}))), []); title('Imagem reconstruída com 20%'); 
vector= abs(low_coef{1}); %getting the magnitude of complex number
vector= reshape(vector, 1, []); %formating the response to one line to compose the final_vector

end