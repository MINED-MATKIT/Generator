function costmap = GetObjectStatsCostFunction(Image,object,targetstats,radiusrange,taper,relaxation)

% Parse and Organize Inputs
if numel(setdiff(unique(Image),[0 1])) ~= 0
    error('Image must be binary at this point!')
end

if numel(setdiff(unique(object),[0 1])) ~= 0
    error('Object must be binary at this point!')
end
    
if ~strcmp(radiusrange,'full') && (~isnumeric(radiusrange) || length(radiusrange) > 2)
   error('Radius range has to be a scalar or a pair of scalars!'); 
end

if ~ismember(taper,{'gaussian','absolute',''}) 
   error('Taper can only be one of ''gaussian'' or ''absolute''!')     
end

if ~isscalar(relaxation)
   error('Relaxation paramater has to be a scalar!'); 
end
    
if numel(radiusrange) == 1
    radiusrange = [radiusrange, radiusrange];
end

% Calculate Weighting Matrix from Radius Range, Taper and Relaxation
if strcmp(radiusrange,'full')
    
    lengtscaleweights = 1;
    
else

    if ismatrix(Image)

        inner = getnhood(strel('disk',radiusrange(1),0));
        outer = getnhood(strel('disk',radiusrange(2),0));
        lengtscaleweights = outer - inner;

    elseif ndims(Image) == 3

        inner = getnhood(strel('sphere',radiusrange(1)));
        outer = getnhood(strel('sphere',radiusrange(2)));
        lengtscaleweights = outer - inner;

    end

    if strcmp(taper,'gaussian')

        if ismatrix(Image)
            tapermap = imgaussfilt(lengtscaleweights,relaxation,'Padding','circular');
            lengtscaleweights(lengtscaleweights~=1) = tapermap(lengtscaleweights~=1);
        elseif ndims(Image) == 3
            tapermap = imgaussfilt3(lengtscaleweights,relaxation,'Padding','circular');
            lengtscaleweights(lengtscaleweights~=1) = tapermap(lengtscaleweights~=1);
        end

    elseif strcmp(taper,'absolute')  

        % Do Nothing.

    end

end
% Find Statistics of Current Image
currentstats = FFTimfilter(Image,Image);

% Find Error in Statistics (also accounts for the internal effect of object)
statstep = targetstats - currentstats;
objectstats = FFTimfilter(object,object);
statstep = statstep - BorderPadArray2Size(objectstats,size(statstep));

% Apply Lengthscale Weights
statstep = statstep.*lengtscaleweights;

% Obtain Stepmap for a Pixel Placement
stepmap = FFTimfilter(Image,statstep);

% Overlay Stepmap with Desired Image Region to Exclude
stepmap(Image==1) = 0;

% Obtain Costmap for the Object Placement
stepmap = FFTimfilter(stepmap,object);

% Normalize Costmap
costmap = stepmap./max(stepmap(:));
