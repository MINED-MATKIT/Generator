function costmap = GetOverlapCostFunction(overlapmap,overlapfraction,taper,relaxation)

% Parse and Organize Inputs
if ~isnumeric(overlapfraction) || length(overlapfraction) > 2
   error('Overlap fraction has to be a scalar or a pair of scalars!'); 
end

if ~ismember(taper,{'gaussian','absolute'}) 
   error('Taper can only be one of ''gaussian'' or ''absolute''!')     
end

if ~isscalar(relaxation)
   error('Relaxation paramater has to be a scalar!'); 
end

if numel(overlapfraction) == 1
    overlapfraction = [overlapfraction, overlapfraction];
end

% Get initial cost function.
costmap = double((overlapmap >= overlapfraction(1)) & (overlapmap <= overlapfraction(2)));

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