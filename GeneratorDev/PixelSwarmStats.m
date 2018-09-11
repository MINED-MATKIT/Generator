function [currentstats, costmap] = PixelSwarmStats(Image,roilabel,targetstats,iter)

% Parse and Organize Inputs
if numel(setdiff(unique(Image),[0 1])) ~= 0
    error('Image must be binary at this point!')
end

% Find Statistics of Current Image
currentstats = FFTimfilter(Image,Image);



%%

for ii = 1:iter
    
    % Find Error in Statistics (also accounts for the internal effect of object)
    statstep = targetstats - currentstats;

    % Obtain Stepmap for a Pixel Placement
    stepmap = FFTimfilter(Image,statstep);

    % Overlay Stepmap with Desired Image Region to Exclude
    stepmap(Image==1) = 0;

    % Normalize Costmap
    costmap = stepmap./max(stepmap(:));

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

            case 'weightedborder'

                dmap = bwdist(costmap>0,'chessboard');
                dmap = dmap == 1;
                costmap = costmap.*dmap;
                ind = randsample(1:numel(Image),1,true,costmap(:));
                [xx, yy, zz]=ind2sub(size(Image),ind);      

        end
    end

    Image(xx,yy,zz) = 1;
    
    
    %%
    currentstats = currentstats + circshift(ifftshift(Image),[-xx,-yy,-zz]);
    
end 
    
    
    





