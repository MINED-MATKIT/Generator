function Image = BorderPadArray2Size(Image, newsize, varargin)
%N-D border padding to specified size.
% BorderPadArray2Size(image, newsize) pads an N-D 'image' such that   
% the padded size is equal to "newsize". The image is centered during
% padding with filtering applications in mind.
% BorderPadArray2Size(image, newsize, padval) will accept the
% 'padval' parameter from padarray, changing the padding value from the
% default (0).
%
%Example usage:
% BorderPadArray2Size(image, [51 51 71]);
%
%Copyright (c) 2017, <a href="matlab: 
% web('http://www.ahmetcecen.tech/')">Ahmet Cecen</a>  -  All rights reserved.
%
%See also PADARRAY, IFFTSHIFT.

% Entertain other padding values.
padval = 0;
if nargin == 3
    padval = varargin{1};
elseif nargin > 3
    error('Too many input arguments!');
end

% Find required padding.
padsize = newsize - size(Image);

% Get pre and post pad sizes, this is required for cases when the padding
% is an odd number (or newsize is even) to ensure compatibility with
% MATLAB conventions in other tools such as ifftshift.
presize = ceil(padsize/2);
postsize = floor(padsize/2);

% Do the padding using padarray.
Image = padarray(Image,presize,padval,'pre');
Image = padarray(Image,postsize,padval,'post');

end