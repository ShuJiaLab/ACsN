%% CAMERA CALIBRATION
% This script evaluates the offset and gain maps of a digital camera
% according to the procedure reported in [1]. Other useful information for
% an accurate gain calibration can be found in [2].
%
% Please, be aware that some sCMOS cameras have two gain regimes (low and
% high intensity), in which case two different gain maps should be
% produced. Refer to the camera manual or manufacturer's website for more
% specific information about your device.
%
% [1] Huang, F., Hartwich, T., Rivera-Molina, F. et al. Video-rate
%     nanoscopy using sCMOS camera–specific single-molecule localization
%     algorithms. Nat Methods 10, 653–658 (2013).
%     https://doi.org/10.1038/nmeth.2488
%
% [2] James R. Janesick, Photon Transfer, SPIE (2007)
%     https://doi.org/10.1117/3.725073 

% It may be convenient to store all calibration variables in one file 
% but, when using the ACsN GUI, it is necessary to store offset and gain 
% in different .mat files.
save_one_file  = 0; 

%% Offset and Variance

% Offset and Variance calibration is performed evaluating respectively
% average and variance of one or more data stacks acquired with no light
% entering the camera.

% This code assumes that all data stacks for Offset and Variance
% calibration share the same initials. However this can be changed by
% modifying the argument of dir function.

[file,path] = uigetfile('*.tif*');
if isequal(file,0)
    disp('User selected Cancel');
    return
else
    D = dir([path, file(1:4), '*.tif*']);
    L = length(D);
    t = 0;
    for i = 1:L
        disp(['Loading ', fullfile(path,D(i).name)]);
        im = double(loadtiff(fullfile(path,D(i).name)));
        if i == 1
            row = size(im,1);
            col = size(im,2);
            Offset = zeros(row,col);
            Variance = zeros(row,col);
        end
        
        for j = 1:size(im,3)
            t = t + 1;
            Offset = ((t-1)/t).*Offset + im(:,:,j)./t; 
            Variance = ((t-1)/t).*Variance + ((im(:,:,j)-Offset).^2)./(t-1); 
        end
    end
end

if save_one_file
    save('Camera_Calibration','Offset','Variance');
else
    save('Offset','Offset');
    save('Variance','Variance');
end

%% Gain calibration

% Here the code assumes that the image stacks for gain calibration have been saved
% in different folders, one for each different illumination intensity and in
% .tiff files that begin with 'Gain'. However, this can be changed by modifying
% the argument of the dir function.
    
% N is the number of light levels used for gain calibration
N = 10; 

%row = size(Offset,1);
%col = size(Offset,2);
G = zeros(row,col,N);
V = zeros(row,col,N);
        
for i = 1:N
    [file,path] = uigetfile('*.tif*');
    if isequal(file,0)
        disp('User selected Cancel');
        return
    else
        D = dir([path, file(1:4), '*.tif*']);
        L = length(D);
        t = 0;
        for k = 1:L
            im = double(loadtiff(fullfile(path,D(k).name)));
            for j = 1:size(im,3)
                t = t + 1;
                G(:,:,i) = ((t-1)/t).*G(:,:,i) + im(:,:,j)./t; 
                V(:,:,i) = ((t-1)/t).*V(:,:,i) + ((im(:,:,j)-G(:,:,i)).^2)./(t-1); 
            end
        end
    end
end

%row = size(G,1);
%col = size(G,2);
Gain = zeros(row,col);

for i = 1:row
    for j = 1:col
        
        A = (squeeze(V(i,j,:) - Variance(i,j)));
        
        B = (squeeze(G(i,j,:) - Offset(i,j)));
        
        Gain(i,j) = lsqminnorm(B,A);
        
    end
end

if save_one_file
    save('Camera_Calibration','Gain','-append');
else
    save('Gain','Gain');
end
