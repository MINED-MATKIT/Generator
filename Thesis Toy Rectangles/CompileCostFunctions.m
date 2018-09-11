function costmap = CompileCostFunctions(Image,object,target,constraints,aggregation)

% Check Inputs
numconstraints = length(constraints);
for ii = 1:numconstraints
    if ~isa(constraints{ii},'ObjectPlacementConstraint')
        error('Constraints can only contain ObjectPlacementConstraint objects in a cell!');
    end
end

% Aggregator
if strcmp(aggregation,'plus')
    aggregator = @(A,B) plus(A,B);
    costmap = zeros(size(Image));
elseif strcmp(aggregation,'times') 
    aggregator = @(A,B) times(A,B);
    costmap = ones(size(Image));
else
    error('Aggregator has to be ''plus'' or ''times''!');
end

% Compute Each Cost Function and Aggregate
for ii = 1:numconstraints
    
    currentConstraint = constraints{ii};
    
    if currentConstraint.UseFlag
        
        if strcmp(currentConstraint.CostType,'overlap')
            
            overlapmap = GetOverlapMap(Image,object,currentConstraint.ImageROILabel,currentConstraint.ObjectROILabel);
            currentcostmap = GetOverlapCostFunction(overlapmap,currentConstraint.Range,currentConstraint.Taper,currentConstraint.Relaxation);
            
        elseif strcmp(currentConstraint.CostType,'seperation')
            
            overlapmap = GetOverlapMap(Image,object,currentConstraint.ImageROILabel,currentConstraint.ObjectROILabel);
            currentcostmap = GetSeperationCostFunction(overlapmap,currentConstraint.Range,currentConstraint.Taper,currentConstraint.Relaxation);
            
        elseif strcmp(currentConstraint.CostType,'spatialstats')
            
            if isempty(target)
                errordlg('Must designate target spatial statistics!')
            else
                currentcostmap = GetObjectStatsCostFunction(Image,object,target,currentConstraint.Range,currentConstraint.Taper,currentConstraint.Relaxation);
            end
            
        end
        
        costmap = aggregator(costmap,currentcostmap);
        
    end
    
end

