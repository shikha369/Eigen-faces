clear all;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%% loading data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prjmatrix=load('projMatrix');
sinsignal=load('Signal');
Xaxis=1:256;
%%%%%%%%%%%%%%%%%%%%%%%%%%%% ploting signal %%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
figure;
plot(sinsignal);
title('Original Signal');
[m,n]=size(prjmatrix);
basis=ones(256,1);
%%%%%%%%%%%%%%%%%%%%%% converting into complex matrix %%%%%%%%%%%%%%%%%%
for i=1:2:n-1
    basis=[basis complex(prjmatrix(:,i),prjmatrix(:,i+1))];
end 
basis = basis(:,2:end);
projection=basis*sinsignal;
magnitude=abs(projection);
sum(imag(projection));
%%%%%%%%%%%%%%%%%%%%%%%%% ploting magnitude vs directions %%%%%%%%%%%%
figure;
plot(Xaxis,magnitude,'b','lineWidth',2);
xlabel('Basis'); % x-axis label
ylabel('Magnitude of projection'); 
title('Magnitudes of the projection as a function of the basis');
%%%%%%%%%%%%%%%%%%%%%%%%%% Sorted magnitude plot %%%%%%%%%%%%%%%%%%%%
[new_magnitude,Index] = sort(magnitude,'descend');
figure;
plot(Xaxis,new_magnitude,'b','lineWidth',2);
xlabel('Basis'); % x-axis label
ylabel('Sorted Magnitude of projection'); 
title('Magnitudes of the projection as a function of the basis');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
compare_sin=sinsignal(Index,:);
conjugate_basis=ctranspose(basis)/m;
e=1;
for k=1:1:255
    new_proj=projection;
    for i=k+1:m
        new_proj(Index(i))=0;
    end
    %%%%%%%%%%%%%%%%%%%%%%% reconstructing signals %%%%%%%%%%%%%%%%%%%%%%%
     reconstructed_signal=conjugate_basis*new_proj;
     error=norm(sinsignal-real(reconstructed_signal),'fro')/norm(sinsignal,'fro')*100;
     if(error<1)
             break;
     end
    %%%%%%%%%%%%%%%%%%%%%% plot reconstructed signal %%%%%%%%%%%%%%%%%%%%%
    figure;
     plot(imag(reconstructed_signal));
     xlabel('t');
     ylabel('f(t)');
     title(['Imaginary part of Reconstructed Signal for Top ' num2str(k)]);
   
   figure;
   plot(real(reconstructed_signal));
   xlabel('t');
   ylabel('f(t)');
   title(['Real part of Reconstructed Signal for Top ' num2str(k)]);
   
   %%%%%%%%%%%%%%%%%% plot differnce between signals %%%%%%%%%%%%%%%%%%%%
   figure;
    plot(sinsignal-real(reconstructed_signal));
    xlabel('t');
    ylabel('f(t)');
    title(['Signal Difference for Top ' num2str(k)]);
    legend(['Error in percentage ' num2str(error)]);

%%%%%%%%%%%%%%%%%%%%%%% storing error %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    err(e,1)=k;
    err(e,2)=error;
    e=e+1;
end

sum(imag(reconstructed_signal))
%%%%%%%%%%%%%%%%%%%%%%%%%%% bar graph %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
    bar(err(:,1),err(:,2),'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.5);
    hold on;
    xlabel('Top K Directions'); % x-axis label
    ylabel('Relative Error in percentage'); 
    title('Bar Graph:Error');
%%%%%%%%%%%%%%%%%%%%%%%%% Error graph %%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
plot(err(:,1),err(:,2),'r','lineWidth',2);
xlabel('Top K Directions'); % x-axis label
ylabel('Relative Error in percentage'); 
title('Error Graph');
