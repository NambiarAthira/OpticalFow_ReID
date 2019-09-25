%% Nearest Neighbor computation for re-id
% Load the people's descriptor into a matrix along with a corresponding
% label matrix

%% Make the dataset
noPersons=3; % No of persons
Dataset=[];
Dataset_label=[];
output_class=[];

for i=1:noPersons
       load(strcat(int2str(i),'.mat'));% Load the matfile of descriptor for person i
       Dataset=[Dataset;s];
       Dataset_label=[Dataset_label;i*ones(1,size(s,1))']
end

%% Test for each sample descriptor keeping the rest N-1 descriptors as the training set

for cnt=1:size(Dataset,1)
    index=zeros(size(Dataset,1),1)
    index(cnt)=1    
    sample=Dataset(find(index==1),:)
    sample_label=Dataset_label(find(index==1),:)
    training=Dataset(find(index==0),:)
    training_label=Dataset_label(find(index==0),:)
    group=training_label
    class = knnclassify(sample, training, group)
    output_class=[output_class;class]
end
  






















% 
% person = strtrim(cellstr( num2str((1:noPersons)','id%d') ));          %'# each persons id place
% 
% % For each person collect their corresponding descriptor and store it
% for i=1:noPersons
%     filename=strcat(int2str(i),'.mat');
%     S.(person{i}) = load(filename);         
% end
% 
% for i=1:noPersons
%      sample= S.(person{i}).s(j,:) ;
%      label_sample=i;
% end
