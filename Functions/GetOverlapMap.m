function overlapmap = GetOverlapMap(Image,object,imageroilabel,objectroilabel)


% Parse and Organize Inputs
if strcmp(imageroilabel,'full')
    Image = double(Image ~= 0);
elseif isscalar(imageroilabel) 
    Image = double(Image == imageroilabel);
else
    error('Incorrect ROI label! Can either be ''full'' or a scalar.')
end

if strcmp(objectroilabel,'full')
    object = double(object ~= 0);
elseif isscalar(objectroilabel) 
    object = double(object == objectroilabel);
else
    error('Incorrect ROI label! Can either be ''full'' or a scalar.')
end

% Calculate sensitivity to get rid of machine precision errors.
sensitivity = min(min(abs(Image(Image~=0))),min(abs(object(object~=0))));
if isempty(sensitivity)
    sensitivity = 0;
end

% Get overlap scores.
overlapmap = FFTimfilter(Image,object);
overlapmap(abs(overlapmap)<=sensitivity)= 0;
overlapmap = overlapmap./sum(object(:))*100;

end