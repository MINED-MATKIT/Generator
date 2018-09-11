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


object = ifftshift(object);
objectmask = ifftshift(objectmask);


%% Various Cost Functions with Flags
ymap = ifftn(fftn(alpha).*conj(fftn(objectmask)));


% Placement by Seperation - min/max - absolute - FINALIZED


% Placement by Overlap Percent - range - FINALIZED-ish


% Placement by Overlap on marked ROIs at placement (branches, always at the tip of a rectangle etc) - range
% simply overlap but with object == roilabel instead of object ~= 0


% Placement by Spatial Statistics

% Mind the placement of pixels vs shapes.






% JOINING COST FUNCTIONS
% Additive
% Multiplicative
% Custom
% Add min cost globally - like nothing smaller than 0.1


% MORE:
% Placement by Tortuosity?
% Preserve Connectivity? 
% Ensure Connectivity?
% Placement by Connectivity at marked ROIs - Like legos - range?

%% Generate Code for BATCH generation!!!!


%% Various Choosing Placement with Flags
ind=find(round(ymap)==0);
ind=ind(randi(length(ind))); %% SLOW
[xx, yy, zz]=ind2sub(size(alpha),ind(1));



%% Actual Placement - Trivial - Maybe allow multiple at a time. MAYBE - Probably as expensive as a new placement.
object=circshift(object,[xx yy zz]);

% MAYBE use the original window size of the object as a boundary for
% multiple placement.

% Fill a different canvas then apply to main canvas for multiple placement.
% MAYBE
alpha(rect~=0)=rect(rect~=0);