function costmap = GetSeperationCostFunction(overlapmap,seperation,taper,relaxation)

% Parse and Organize Inputs
if ~isnumeric(seperation) || length(seperation) > 2
   error('Seperation has to be a scalar or a pair of scalars!'); 
end

if ~ismember(taper,{'gaussian','absolute'}) 
   error('Taper can only be one of ''gaussian'' or ''absolute''!')     
end

if ~isscalar(relaxation)
   error('Relaxation paramater has to be a scalar!'); 
end

if numel(seperation) == 1
    seperation = [seperation, seperation];
end

% Hard Code Distance Measure for Now
distancemethod = 'euclidean';

% Obtain distance maps from overlap scores.
positivedistancemap = bwdist(overlapmap>0,distancemethod);
negativedistancemap = bwdist(overlapmap==0,distancemethod);
distancemap = positivedistancemap - negativedistancemap;
distancemap(distancemap>0) =  distancemap(distancemap>0) -1;

% Get initial cost function.
costmap = double((distancemap >= seperation(1)) & (distancemap <= seperation(2)));

% Apply any tapering requested.
if strcmp(taper,'gaussian')
    
    if ismatrix(overlapmap)
        tapermap = imgaussfilt(costmap,relaxation,'Padding','circular');
        costmap(costmap~=1) = tapermap(costmap~=1);
    elseif ndims(overlapmap) == 3
        tapermap = imgaussfilt3(costmap,relaxation,'Padding','circular');
        costmap(costmap~=1) = tapermap(costmap~=1);
    end
    
elseif strcmp(taper,'absolute')  
    
    % Do Nothing.
    
end


end