close all

load('cmap');
load('gain');
load('offset');

NA = 1.45;
Lambda = .680;
PxSize = .065;

input1 = double(loadtiff('TIRF_100Hz.tif'));

acsn_100  = ACSN(input1,NA,Lambda,PxSize,'Offset',offset,'Gain',gain); 
figure; 
imagesc(imfuse(input1,acsn_100,'montage'));
colormap(blow); axis off; axis image;
title('TIRF image of HeLa microtubules recorded at 100 Hz');


input2 = double(loadtiff('TIRF_200Hz.tif'));

acsn_200  = ACSN(input2,NA,Lambda,PxSize,'Offset',offset,'Gain',gain,'Mode','Parallel'); 
figure; 
imagesc(imfuse(input2(:,:,1),acsn_200(:,:,1),'montage'));
colormap(blow); axis off; axis image;
title('TIRF image of HeLa microtubules recorded at 200 Hz');