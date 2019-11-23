function formatted_vector= fract_dim_boxcounting(input_img) %this method receives an img as input for box counting
	input_img= imresize(input_img, [512,512]);
	[rows, columns]= size(input_img);
	max_scale= log2(rows); %the max number of the scale is equals to the log of the img dimension
	fd_scale= cell(1, max_scale); %fractal dimension of each scale
	input_img= imbinarize(input_img);
	
	for i=1: max_scale
		number_of_boxes= 2^i;
		denominator= log(number_of_boxes);
		width_box= columns/number_of_boxes;
		height_box= rows/number_of_boxes;
		divide_aux= number_of_boxes;
		number_of_boxes= number_of_boxes^2;
		sub_images= cell(1, number_of_boxes);
		total_boxes_with_objects= 0;
		%now I have the number of the boxes and the size of each one -> I can count the boxes with objects
		
		%first, I divide the complete image into the boxes for counting
		x=1; y=1; extra_count=1;
		for aux_r=1: divide_aux
			for aux_c=1: divide_aux
				sub_images{extra_count}= input_img(x: x+height_box-1, y: y+width_box-1, :);
				extra_count= extra_count+1;
				y= y+width_box;
			end
			y=1; x=x+height_box;
		end
		
		%now I can do the counting in each box
		for j=1: number_of_boxes %for each box
			counter_box=0;
			for k=1: height_box %going through each box
				for m=1: width_box
					if sub_images{j}(k, m)==0 %if there is object in the box, then increments the counter_box
						counter_box= counter_box+1;
					end
				end
			end
			if counter_box>0
				total_boxes_with_objects= total_boxes_with_objects+1;
			end
		end
		nominator= log(total_boxes_with_objects);
		fd_scale{i}= nominator/denominator;
		if i==1
			delta_y= nominator; delta_x= denominator;
		end
		if i==max_scale
			general_fd= ((nominator-delta_y)/(denominator-delta_x)); %general fractal dimension
		end
	end
	
	vector{1}= fd_scale;
	vector{2}= general_fd;
	
	formatted_vector= zeros(1, max_scale+1);
	for form_idx=1: max_scale
		formatted_vector(form_idx)= vector{1}{form_idx};
	end
	formatted_vector(max_scale+1)= vector{2};
	
end