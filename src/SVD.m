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

[U D] = eig(imageArray * imageArray');

eigenValues = diag(D);

for i = 1:165
	V(:,i) = imageArray' * U(:,i)/sqrt(eigenValues(i,1));
end

[values, order] = sort(eigenValues);
sortedEigenVal = eigenValues(flipud(order),:);
UFinal = U(:,flipud(order));
VFinal = V(:,flipud(order));
SFinal = diag(sqrt(eigenValues));
%int64(imageArray - (UFinal*SFinal*VFinal'));
