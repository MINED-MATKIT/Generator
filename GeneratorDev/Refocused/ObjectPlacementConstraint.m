classdef ObjectPlacementConstraint
    %OBJECTPLACEMENTCONSTRAINT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        UseFlag = false;
        CostType = ''; 
        ImageROILabel = [];
        ObjectROILabel = [];
        Range = [];
        Taper = '';
        Relaxation = [];

    end
    
    methods
        function obj = ObjectPlacementConstraint(useflag, costtype, ...
                imageroilabel, objectroilabel, range, taper,...
                relaxation)
            % Class Constructor
            
            if ~islogical(useflag) 
               error('Use Flag can only be a logical!')     
            end
            
            if ~ismember(costtype,{'overlap','seperation','spatialstats'}) 
               error('Cost Type can only be one of ''overlap'', ''seperation'' or ''spatialstats''!')     
            end
            
            if ~isscalar(imageroilabel) && ~strcmp(imageroilabel,'full') 
               error('Image ROI Label paramater has to be a scalar!'); 
            end
            
            if ~isscalar(objectroilabel) && ~strcmp(objectroilabel,'full') 
               error('Object ROI Label paramater has to be a scalar!'); 
            end
            
            if (~isnumeric(range) || length(range) > 2) && ~strcmp(range,'full') 
               error('Range has to be a scalar or a pair of scalars!'); 
            end

            if ~ismember(taper,{'gaussian','absolute'}) 
               error('Taper can only be one of ''gaussian'' or ''absolute''!')     
            end

            if ~isscalar(relaxation)
               error('Relaxation paramater has to be a scalar!'); 
            end

            if numel(range) == 1
                range = [range, range];
            end

            obj.CostType = costtype; 
            obj.ImageROILabel = imageroilabel;
            obj.ObjectROILabel = objectroilabel;
            obj.Range = range;
            obj.Taper = taper;
            obj.Relaxation = relaxation;
            obj.UseFlag = useflag;
   
        end
    end
    
end

