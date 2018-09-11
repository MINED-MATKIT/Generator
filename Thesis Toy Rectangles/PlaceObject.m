function Image = PlaceObject(Image, object, costmap, heuristic, varargin)

% Find a location to place the object according to heuristic.
if nnz(Image) == 0
    xx = randi(size(Image,1));
    yy = randi(size(Image,2));
    zz = randi(size(Image,3));
else
    switch heuristic

        case 'thresholdedrandom'

            threshold = varargin{1};
            ind=find(costmap > threshold);
            ind=ind(randi(length(ind)));
            [xx, yy, zz]=ind2sub(size(Image),ind);

        case 'weightedrandom'
            
            ind = randsample(1:numel(Image),1,true,costmap(:));
            [xx, yy, zz]=ind2sub(size(Image),ind);

        case 'percentilerandom'

            threshold = prctile(costmap(:),90);
            ind=find(costmap > threshold);
            ind=ind(randi(length(ind)));
            [xx, yy, zz]=ind2sub(size(Image),ind);

    end
end

% Place Object
object = ifftshift(BorderPadArray2Size(object, size(Image)));
object = circshift(object, [xx yy zz]);
Image(object~=0)=object(object~=0);

end