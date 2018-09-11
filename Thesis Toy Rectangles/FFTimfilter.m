function B = FFTimfilter(A,h)

% Check Inputs
if ndims(A) ~= ndims(h)
    error('A and h must both be 2D or 3D!');
elseif ~isnumeric(A) || ~isnumeric(h)
    error('A and h must be numeric!');
elseif sum((size(A)-size(h))<0)>0
    error('A must be bigger than h in all dimensions!')
end

% Handshake Sizes
h = BorderPadArray2Size(h, size(A));
B = ifftn(fftn(A).*conj(fftn(ifftshift(h))));