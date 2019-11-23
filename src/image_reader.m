function array= image_reader(path)%reading all images of the folder
	my_folder= path;
	file_pattern= fullfile(my_folder, '*.tif');%creates a file with all images in the TIF format from the desired folder
	list= dir(file_pattern);%list the files into the folder
	array= cell(1, length(list)); %creates a 1D array for the size of the list
	for i=1: length(list)
		imgfile_name= list(i).name;
		completefile_name= fullfile(my_folder, imgfile_name); %build a complete path from the sub-paths
		array{i}= imread(completefile_name);
	end
end