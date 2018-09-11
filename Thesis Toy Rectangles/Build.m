%%
Image = double(~Data);

object = imrotate(rect,135,'crop');

rr = getnhood(strel('disk',31,0));
rr = double(BorderPadArray2Size(rr, size(rect)));
targetstats = FFTimfilter(rr,rr);
targetstats(targetstats<0) = 0;

radiusrange = 10;

taper = 'gaussian';

relaxation = 5;


%%

% This is a very poor function and needs to be improved. Many edge cases.

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
    radiusrange = [0, radiusrange];
end

% Calculate Weighting Matrix from Radius Range, Taper and Relaxation
if strcmp(radiusrange,'full')
    
    lengtscaleweights = 1;
    
else

    if ismatrix(Image)

        if radiusrange(1) == 0
            inner = zeros(size(Image));
        else
            inner = BorderPadArray2Size(getnhood(strel('disk',radiusrange(1),0)),size(Image));
        end
        outer = BorderPadArray2Size(getnhood(strel('disk',radiusrange(2),0)),size(Image));
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

%% Plot Neighborhood Weight
imagesc(lengtscaleweights); axis image;
xticks([1 26 51 76 101]);
xticklabels({'-50','-25','0','25','50'})
yticks([1 26 51 76 101]);
yticklabels({'-50','-25','0','25','50'})
set(gca, 'Ydir', 'normal')
set(gca,'FontSize',16);
colorbar

%%
% Find Statistics of Current Image
currentstats = FFTimfilter(Image,Image);

%% Plot Current Stats
imagesc(currentstats/numel(Image)); axis image; caxis([0 0.3])
xticks([1 26 51 76 101]);
xticklabels({'-50','-25','0','25','50'})
yticks([1 26 51 76 101]);
yticklabels({'-50','-25','0','25','50'})
set(gca,'FontSize',16);
colorbar
set(gca, 'Ydir', 'normal')

%% Plot Current Stats
imagesc(targetstats/numel(Image)); axis image; caxis([0 0.3])
xticks([1 26 51 76 101]);
xticklabels({'-50','-25','0','25','50'})
yticks([1 26 51 76 101]);
yticklabels({'-50','-25','0','25','50'})
set(gca,'FontSize',16);
colorbar
set(gca, 'Ydir', 'normal')

%%
% Find Error in Statistics (also accounts for the internal effect of object)
statstep = targetstats - currentstats;

%% Plot Step
imagesc(statstep/numel(Image)); axis image; caxis([0 0.3])
xticks([1 26 51 76 101]);
xticklabels({'-50','-25','0','25','50'})
yticks([1 26 51 76 101]);
yticklabels({'-50','-25','0','25','50'})
set(gca,'FontSize',16);
colorbar
set(gca, 'Ydir', 'normal')

%%
objectstats = FFTimfilter(object,object);

%% Plot Step
imagesc(objectstats/numel(Image)); axis image; caxis([0 0.3])
xticks([1 26 51 76 101]);
xticklabels({'-50','-25','0','25','50'})
yticks([1 26 51 76 101]);
yticklabels({'-50','-25','0','25','50'})
set(gca,'FontSize',16);
colorbar
set(gca, 'Ydir', 'normal')

%%
statstep = statstep - BorderPadArray2Size(objectstats,size(statstep));

%% Plot Object Corrected Step
imagesc(statstep/numel(Image)); axis image; caxis([0 0.3])
xticks([1 26 51 76 101]);
xticklabels({'-50','-25','0','25','50'})
yticks([1 26 51 76 101]);
yticklabels({'-50','-25','0','25','50'})
set(gca,'FontSize',16);
colorbar
set(gca, 'Ydir', 'normal')

%%
% Apply Lengthscale Weights
statstep = statstep.*BorderPadArray2Size(lengtscaleweights,size(statstep));

%% Weighted Step
imagesc(statstep/numel(Image)); axis image; caxis([0 0.3])
xticks([1 26 51 76 101]);
xticklabels({'-50','-25','0','25','50'})
yticks([1 26 51 76 101]);
yticklabels({'-50','-25','0','25','50'})
set(gca,'FontSize',16);
colorbar
set(gca, 'Ydir', 'normal')


%%
% Obtain Stepmap for a Pixel Placement
stepmap = FFTimfilter(Image,statstep);
costmap = (stepmap-min(stepmap(:)))./(max(stepmap(:))-min(stepmap(:)));
%% Weighted Step
imagesc(costmap); axis image; caxis([0 1])
xticks([1 101]);
yticks([1 101]);
yticklabels({'101','1'})
axis off
set(gca,'FontSize',16);
colorbar

%%
% Overlay Stepmap with Desired Image Region to Exclude
stepmap(Image==1) = 0;
costmap(Image==1) = 0;

%% Weighted Step
imagesc(costmap); axis image; caxis([0 1])
xticks([1 101]);
yticks([1 101]);
yticklabels({'101','1'})
axis off
set(gca,'FontSize',16);
colorbar

%%
% Obtain Costmap for the Object Placement
stepmap = FFTimfilter(stepmap,object);

%%
% Normalize Costmap
costmap = (stepmap-min(stepmap(:)))./(max(stepmap(:))-min(stepmap(:)));

% Zero Image
if nnz(isnan(costmap)) == numel(costmap)
    costmap = ones(size(costmap));
end

%% Weighted Step
imagesc(costmap); axis image; caxis([0 1])
xticks([1 101]);
yticks([1 101]);
yticklabels({'101','1'})
axis off
set(gca,'FontSize',16);
colorbar