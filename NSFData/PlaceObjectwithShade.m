function [Image, ShadeImage] = PlaceObjectwithShade(Image, ShadeImage, object, objectshade, costmap, heuristic, varargin)

% Find a location to place the object according to heuristic.
if nnz(ShadeImage) == 0
    xx = randi(size(ShadeImage,1));
    yy = randi(size(ShadeImage,2));
    zz = randi(size(ShadeImage,3));
else
    switch heuristic

        case 'thresholdedrandom'

            threshold = varargin{1};
            ind=find(costmap > threshold);
            ind=ind(randi(length(ind)));
            [xx, yy, zz]=ind2sub(size(ShadeImage),ind);

        case 'weightedrandom'
            
            ind = randsample(1:numel(ShadeImage),1,true,costmap(:));
            [xx, yy, zz]=ind2sub(size(ShadeImage),ind);

        case 'percentilerandom'

            threshold = prctile(costmap(:),90);
            ind=find(costmap > threshold);
            ind=ind(randi(length(ind)));
            [xx, yy, zz]=ind2sub(size(ShadeImage),ind);

    end
end

% Place Object
objectshade = ifftshift(BorderPadArray2Size(objectshade, size(ShadeImage)));
objectshade = circshift(objectshade, [xx yy zz]);
ShadeImage(objectshade~=0)=objectshade(objectshade~=0);

object = ifftshift(BorderPadArray2Size(object, size(Image)));
object = circshift(object, [xx yy zz]);
Image(object~=0)=object(object~=0);

end