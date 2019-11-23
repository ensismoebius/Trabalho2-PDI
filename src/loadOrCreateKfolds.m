function [ kfolds ] = loadOrCreateKfolds( amount )
	%LOADORCREATEKFOLDS Load existing k folds or create one
	% Loads the kfold separation previously generated just for the sake of reproducibility.
	% If you want a new kfold separation delete the "kfold.mat" file
	if exist('kfold.mat', 'file')
		file = load('kfold.mat','kfolds');
		kfolds= file.kfolds;
	else
		kfolds= crossvalind('kfold', label_matrix, k); %creating the indices of the folds
		save('kfold.mat','kfolds');
	end
end

