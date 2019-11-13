function filtered_images= filtering_images(image_group, percentage)%this function receives a group and a percetage of
%images that will be filtered -- if I filter all images I can addict my classifier

    proportion_filtered= round(percentage * length(image_group));    
    random_list= randperm(length(image_group), proportion_filtered);

    for i=1: proportion_filtered
        image_group{random_list(i)}= generateMaskedImage(image_group{random_list(i)});
    end
    
    filtered_images= image_group;
end