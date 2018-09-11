function Image = IntrinsicRotate3D(Image, sequence, angles, varargin)
%Successive intrinsic rotations in 3D.
% IntrinsicRotate3D(image, sequence, angles) rotates a 3D 'image' around 
% specified axes in 'sequence', by degrees denoted in 'angles'. 'sequence'
% is a character array composed of 'x', 'y' or 'z' (i.e. 'zyz'), 'angles'
% is a vector of same length as 'sequence' with angles in degrees. 
% IntrinsicRotate3D(image, sequence, angles, method) will accept the
% 'method' parameter from imrotate.
% IntrinsicRotate3D(image, sequence, angles, method, bbox) will accept the
% 'bbox' parameter from imrotate.
%
%Example usage:
% IntrinsicRotate3D(image, 'xyz', [50, -20,47]);
%
%Copyright (c) 2017, <a href="matlab: 
% web('http://www.ahmetcecen.tech/')">Ahmet Cecen</a>  -  All rights reserved.
%
%See also IMROTATE.

% Parse inputs and handle errors.
if length(sequence) ~= length(angles)
    error('''sequence'' and ''angles'' must be same length!');
elseif numel(setdiff(sequence,'xyz')) ~= 0
    error('''sequence'' can only contain rotations around ''x'',''y'' or ''z''!');
end

method = 'nearest';
bbox = 'loose';
if nargin == 4
    method = varargin{1};  
elseif nargin == 5
    bbox = varargin{2};
elseif nargin > 5
    error('Too many input arguments!');
end

% Permute rotation axis as the third dimension in the array, while preserving handedness.
forwardpermute.x = [2 3 1];
forwardpermute.y = [3 1 2];
forwardpermute.z = [1 2 3];

% Re-permute the image to original axes locations.
backwardpermute.x = [3 1 2];
backwardpermute.y = [2 3 1];
backwardpermute.z = [1 2 3];

% Rotate repeatedly as many times as requested.
for ii = 1:length(angles)
    
    % Forward Permutation
    Image = permute(Image,forwardpermute.(sequence(ii)));
    
    % Rotation around an intrinsic axis.
    Image = imrotate(Image,angles(ii),method,bbox);
    
    % Backward Permutation
    Image = permute(Image,backwardpermute.(sequence(ii)));

end

end

