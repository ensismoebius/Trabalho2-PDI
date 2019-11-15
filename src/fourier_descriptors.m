function vector= fourier_descriptors(input_img) %this function receives a img for calculating Fourier descriptors (FD)
%the FD are calculated catching just the high frequencies of the DFT
%if I catch just the coeficients above certain frequency I can reconstruct the img just with the edges
%so, the objective is catch just the frequencies in the middle of the spectrum (without the shift)
%figure(10); imshow(input_img); title('Imagem Original');

coefficients= fft2(input_img); %dft of the image
[rows, columns]= size(coefficients);

%I want just the high frequencies, the edges of the objects -> in the center of the spectrum (10%)
index_highrows= round(rows*0.10);
index_highcolumns= round(columns*0.10);
high_coef= cell(1, 1);
high_coef{1}= coefficients(((rows/2)-(index_highrows/2)): ((rows/2)+(index_highrows/2)), ((columns/2)-(index_highcolumns/2)) : ((columns/2)+(index_highcolumns/2)));

%showing the reconstruction just with the high frequencies (descriptors)
%figure(1); imshow(log(abs(ifft2(high_coef{1}))), []); title('Imagem reconstruída com 10%'); 
vector= abs(high_coef{1}); %getting the magnitude of complex number
vector= reshape(vector, 1, []); %formating the response to one line to compose the final_vector

end