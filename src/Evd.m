clear;
PATH = '';
imgNames = {'centerlight'; 'glasses'; 'happy'; 'leftlight'; 'noglasses'; 'normal'; 'rightlight'; 'sad'; 'sleepy'; 'surprised'; 'wink'};

count = 1;
for i = 1:15
	for j = 3:13
		imageArray(count,:) = reshape(double(imread(char(fullfile(PATH, int2str(i),strcat('subject',sprintf('%.2d', i),'.',imgNames(j-2),int2str(j),'.pgm'))))), 1, []);
		count = count + 1;
	end
end

mean = double(zeros(1,59049));
for i = 1:165
	mean = mean + imageArray(i,:);
end

mean = mean / 165;

for i = 1:165
	meanCentered(i,:) = imageArray(i,:) - mean;
end

[V D] = eig((meanCentered * meanCentered'));

eigenValues = diag(D);

for i = 1:165
	eigVectors(:,i) = meanCentered' * V(:,i)/sqrt(eigenValues(i,1));
end

[values, order] = sort(eigenValues);
sortedEigenVal = eigenValues(flipud(order),:);
sortedEigVectors = eigVectors(:,flipud(order));
%Reconstruction
k = 165;

tempEigenVec = sortedEigVectors(:,1:k);

reconstrImage = meanCentered*tempEigenVec*tempEigenVec';

reconstrImage = reconstrImage + repmat(mean,165,1);
