% ACsN   Automatic Correction of sCMOS-related Noise
%
% SYNOPSIS:
%   [img, sigma, elapsedTime] = ACSN(I,NA,Lambda,PixelSize,PropertyName,PropertyValue)
%
% INPUTS:
%   I
%       Noisy image: variable name or file name (only .tif files)
%   NA
%       Numerical Aperture
%   Lambda
%       Wavelength of the emitter
%   PixelSize
%       Pixel size in the image plane in micron (Camera pixel size divided by the magnification)
%
%   Properties:
%
%       Gain
%           gain map of the Camera
%       Offset
%           map of the Camera offset
%       Video
%           'yes' | 'no' | 'auto' (default)
%       Hotspot    (hotspot removal)
%           0 | 1 (default)
%       Mode
%           'Normal' (default) | 'Parallel'
%       SaveFileName
%           User specified name (the default file name is 'ACSN_<starting date and time>.tiff')
%
%
% OUTPUTS:
%   img
%       Denoised image
%   sigma
%       estimated noise variation
%   elapsedTime
%       elapsed time for the denoising
%
%
% (C) Copyright 2019                Biagio Mandracchia
%     All rights reserved
%
% Biagio Mandracchia, February 2019

function [img, varargout] = ACSN(I,NA,Lambda,PixelSize,varargin) %#ok<INUSD>


%% ouverture
timerVal = tic;
img = zeros(size(I));
sigma = zeros(size(I,3),1);
ACSN_initialization;

%% main theme

if strcmp(Mode,'Parallel')
    ACSN_processing_parallel;
elseif size(I,3)>1
    ACSN_processing_video;
else
    ACSN_processing;
end


%% finale

elapsedTime = toc(timerVal);
fprintf('\nElapsed time:')
disp(elapsedTime);
fprintf('Sigma average:')
disp(mean(sigma(:))); 

out = {sigma,elapsedTime};

for idx = 1:(nargout-1)
    varargout{idx} = out{idx}; %#ok<AGROW>
end

end