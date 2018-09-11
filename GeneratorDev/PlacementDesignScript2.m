%% Make a great OPTS object

GeneratorOptions = struct(...
    '','',... 
    '','',...
    '','',...
    '','',...
    '','',...
    '','',...
    '','',... 
    '','',...
    '','',...
    '','',...
    '','',...
    '','',...
    '',''...
);




%% Inputs = Object, ObjectMask
%% Place Object Function


%% Various Cost Functions with Flags


%% Allow User to Choose Each Time, Can Create Multiple ROI Overlap for Example

Constraints = {...
    ObjectPlacementConstraint('overlap', 'full', 'full', 0, [], 'gaussian', 1); ...
    ObjectPlacementConstraint('overlap', 'full', 'full', 0, 'full', 'gaussian', 1); ...
    ObjectPlacementConstraint('overlap', 'full', 'full', 0, 'full', 'gaussian', 1); ...
    ObjectPlacementConstraint('overlap', 'full', 'full', 0, 'full', 'gaussian', 1)
};

%% Compile Joint Cost

isa(Constraints{1},'ObjectPlacementConstraint')


for i = 1:3
    
    % Full Overlap Map
    overlapmapFull = GetOverlapMap(image,object,'full','full');

    % Full Seperation Cost
    costmapFullSeperation = GetSeperationCostFunction(overlapmapFull,seperation,taper,relaxation,distancemethod);

    % Full Overlap Cost
    costmapFullOverlap = GetOverlapCostFunction(overlapmapFull,overlapfraction,taper,relaxation);

end



% Object Statistics Cost 
costmapStats = GetObjectStatsCostFunction(image,object,targetstats,radiusrange,taper,relaxation);


%% ONLY ONE Statistical Constraint



%% JOINING COST FUNCTIONS
% Additive
% Multiplicative
% Custom
% Add min cost globally - like nothing smaller than 0.1 if already > 0



%% Placement Heuristics





%% Pixel Swarm Refinement

% Stats
while true
    costmap = GetPixelSwarmStatsCostFunction(image,targetstats,radiusrange,taper,relaxation);
    % PLACE SWARM
end

% CLD MAYBE
while true
    % CLD List
    % PLACE POINT
end

%% Cleaning


%% Generate Code for BATCH generation!!!! Basically SAVE and LOAD Opts










