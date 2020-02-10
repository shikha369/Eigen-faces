% load all ev matrix
load('EigenVectors.mat');

% load image one by one
load('face1.pgm');
Tface1=face10;

% plot histogram
figure;
imhist(Tface1);

% reshape image into a vector
[m,n]=size(Tface1);
X1=double(reshape(Tface1,[1,m*n]));
X1=transpose(X1);

% project image into eigenspace
wt=transpose(COEFF)*X1;

% generating intermdiate plots
xaxis=0:m*n-1;
figure;
plot(xaxis,wt);
}

% taking absolute values of weights to sort magnitudes
awt=abs(wt);

figure;
plot(xaxis,awt);


%sort absolute wt first
[SortedEval,I] = sort(awt,'descend');

figure;
plot(xaxis,SortedEval);


SortedEval=wt(I);
figure;
plot(xaxis,SortedEval);

%sorting eigenvecors on the basis of magnitudes
I=transpose(I);
SortedCoeff=COEFF(:,I);
SoretdCoeff=transpose(SortedCoeff);

% 2.c:reconstructing image using top k ev
%  plot all errors...initialise error randomly .. but greater than 1
error=2;

flagErr=0;
flagK=0;

while k <=8464


	recX1=SortedCoeff(:,1:k)*SortedEval(1:k,:);

	%use it when u want to get get correcsponding eigenface
	% recX1=SortedCoeff(:,k)*SortedEval(k,:);

	%RECONSTRUCTING IMAGE
	recX1=uint8(recX1);
	recface=reshape(recX1,[m,n]);

	% calculate error using frobenius norm
	delIm=recface-Tface1;
	error = (norm(double(delIm),'fro')/norm(double(Tface1),'fro'))*100;

	%store k val for 1 percent error
	if(flagErr==0 && flagK==0 && error<1)
    	flagErr=1;
  
  	flagK=1;
    	minK=k;
    	minErr=error;
    	figure;
    	imshow(recface);
end

% show intermediate faces and respective error
if(k==5||k==500||k==1000||k==2000||k==5000)
    display(k);
    figure;
    imshow(recface);
    figure;
    imshow(delIm);
    display(error);
end

% store error array
err(k,1)=k;
err(k,2)=error;

k=k+1;
end


%results
figure;
plot(err(:,1),err(:,2),'r','lineWidth',2);
xlabel('To K directions');
ylabel('Error');
title('Error Vs Top-K EigenVectors');
figure;
display(minK);
display(minErr);

display(k);
display(error);
imshow(recface);
