%% Initialize
NewImage = zeros(173,245);
ShadeImage = zeros(173,245);

load ObjectLibrary.mat

target = FFTimfilter(double(BW), double(BW));

% current = FFTimfilter(double(ans), double(ans));

%%
% error = 10;
iter = 0;

for ii = 1:1

%     error = 10;
%     while error > 0.018

        NewImage = zeros(173,245);
        ShadeImage = zeros(173,245);

        while nnz(ShadeImage)/numel(BW) < nnz(BW)/numel(BW)

            randomindex = randi(length(ObjectShadeLibrary));
            rotationindex = randi(360);   

            objectshade = ObjectShadeLibrary{randomindex};
            object = ObjectLibrary{randomindex};   

            object = imrotate(object,rotationindex,'bilinear');
            objectshade = imrotate(objectshade,rotationindex,'nearest');

            Constraint1 = ObjectPlacementConstraint(true, 'overlap', 1, 1, [0 50], 'absolute', 0);
%             Constraint2 = ObjectPlacementConstraint(true, 'spatialstats', 1, 1, [0 20], 'gaussian', 5);
            Constraint2 = ObjectPlacementConstraint(true, 'spatialstats', 1, 1, 'full', 'gaussian', 5);
            Constraints = {Constraint1,Constraint2};

            costmap = CompileCostFunctions(ShadeImage,objectshade,target,Constraints,'times');

            [NewImage, ShadeImage] = PlaceObjectwithShade(NewImage, ShadeImage, object, objectshade, costmap, 'weightedrandom');

        end

        A1 = FFTimfilter(double(BW),double(BW));
        A2 = FFTimfilter(double(ShadeImage),double(ShadeImage));

        error = norm(A1-A2)/norm(A1)

        figure;
        imagesc(A1-A2);
        figure;
        imagesc(ShadeImage);

        iter = iter + 1

%     end

Layers{ii} = ShadeImage;

end

%%
error = 10;
iter = 0;

for ii = 1:1

%     while error > 0.018

        NewImage = zeros(173,245);
        ShadeImage = zeros(173,245);

        while nnz(ShadeImage)/numel(BW) < nnz(BW)/numel(BW)

            randomindex = randi(length(ObjectShadeLibrary));
            rotationindex = randi(360);   

            objectshade = ObjectShadeLibrary{randomindex};
            object = ObjectLibrary{randomindex};   

            object = imrotate(object,rotationindex,'bilinear');
            objectshade = imrotate(objectshade,rotationindex,'nearest');

            Constraint1 = ObjectPlacementConstraint(true, 'overlap', 1, 1, [0 100], 'absolute', 0);
%             Constraint2 = ObjectPlacementConstraint(true, 'spatialstats', 1, 1, [0 20], 'gaussian', 5);
            Constraints = {Constraint1};

            costmap = CompileCostFunctions(ShadeImage,objectshade,target,Constraints,'times');

            [NewImage, ShadeImage] = PlaceObjectwithShade(NewImage, ShadeImage, object, objectshade, costmap, 'weightedrandom');

        end

        A1 = FFTimfilter(double(BW),double(BW));
        A2 = FFTimfilter(double(ShadeImage),double(ShadeImage));

        error = norm(A1-A2)/norm(A1)
        
        figure;
        imagesc(A1-A2);
        figure;
        imagesc(ShadeImage);


        iter = iter + 1

%     end

LayersNoStats{ii} = ShadeImage;

end



%%
for i=1:5
    figure
    imagesc(LayersNoStats{i});axis image;
end




%% Visualize Gray
NewImage2 = NewImage;

Background = 0.35 + 0.2*(round(rand(size(im3)),2) - 0.5);
%Background = FFTimfilter(Background,ones(3,3))/9;

NewImage2(NewImage2==0) = Background(NewImage2==0);

NewImage2 = FFTimfilter(NewImage2,ones(2,2))/4;
NewImage2(NewImage~=0) = NewImage(NewImage~=0);

imagesc(NewImage2)
axis image
colormap gray



%% Test Generation Behavior Stats vs Non Stats Over 100 Samples
% error = 10;
iter = 0;
StatErrMap = zeros(size(BW));
StatAbsErrMap= zeros(size(BW));

for ii = 1:100

%     error = 10;
%     while error > 0.018

        NewImage = zeros(173,245);
        ShadeImage = zeros(173,245);

        while nnz(ShadeImage)/numel(BW) < nnz(BW)/numel(BW)

            randomindex = randi(length(ObjectShadeLibrary));
            rotationindex = randi(360);   

            objectshade = ObjectShadeLibrary{randomindex};
            object = ObjectLibrary{randomindex};   

            object = imrotate(object,rotationindex,'bilinear');
            objectshade = imrotate(objectshade,rotationindex,'nearest');

            Constraint1 = ObjectPlacementConstraint(true, 'overlap', 1, 1, [0 50], 'absolute', 0);
%             Constraint2 = ObjectPlacementConstraint(true, 'spatialstats', 1, 1, [0 20], 'gaussian', 5);
            Constraint2 = ObjectPlacementConstraint(true, 'spatialstats', 1, 1, 'full', 'gaussian', 5);
            Constraints = {Constraint1,Constraint2};

            costmap = CompileCostFunctions(ShadeImage,objectshade,target,Constraints,'times');

            [NewImage, ShadeImage] = PlaceObjectwithShade(NewImage, ShadeImage, object, objectshade, costmap, 'weightedrandom');

        end

        A1 = FFTimfilter(double(BW),double(BW));
        A2 = FFTimfilter(double(ShadeImage),double(ShadeImage));

%         errorStatsFull(ii) = norm(A1-A2)/norm(A1)

        StatErrMap = StatErrMap + A2-A1;
        StatAbsErrMap = StatAbsErrMap + abs(A2-A1);

        iter = iter + 1

%     end

        StatLayers{ii} = ShadeImage;

end


NoStatErrMap = zeros(size(BW));
NoStatAbsErrMap= zeros(size(BW));

for ii = 1:100

%     error = 10;
%     while error > 0.018

        NewImage = zeros(173,245);
        ShadeImage = zeros(173,245);

        while nnz(ShadeImage)/numel(BW) < nnz(BW)/numel(BW)

            randomindex = randi(length(ObjectShadeLibrary));
            rotationindex = randi(360);   

            objectshade = ObjectShadeLibrary{randomindex};
            object = ObjectLibrary{randomindex};   

            object = imrotate(object,rotationindex,'bilinear');
            objectshade = imrotate(objectshade,rotationindex,'nearest');

            Constraint1 = ObjectPlacementConstraint(true, 'overlap', 1, 1, [0 100], 'absolute', 0);
%             Constraint2 = ObjectPlacementConstraint(true, 'spatialstats', 1, 1, [0 20], 'gaussian', 5);
            Constraints = {Constraint1};
            
            costmap = CompileCostFunctions(ShadeImage,objectshade,target,Constraints,'times');

            [NewImage, ShadeImage] = PlaceObjectwithShade(NewImage, ShadeImage, object, objectshade, costmap, 'weightedrandom');

        end

        A1 = FFTimfilter(double(BW),double(BW));
        A2 = FFTimfilter(double(ShadeImage),double(ShadeImage));

%         errorStatsFull(ii) = norm(A1-A2)/norm(A1)

        NoStatErrMap = NoStatErrMap + A2-A1;
        NoStatAbsErrMap = NoStatAbsErrMap + abs(A2-A1);

        iter = iter + 1

%     end

        StatLayers{ii} = ShadeImage;

end

%%

figure;
imagesc(StatErrMap/100/nnz(A1)); axis image; colorbar; set(gca,'FontSize',20);set(gca,'YDir','normal');
xticks([1,123,245]); xticklabels({'-120','0','120'});
yticks([1,87,173]); yticklabels({'-85','0','85'}); colormap(jet)
caxis([-1500 1500]/nnz(A1));

%%
% figure;
% imagesc(StatAbsErrMap/100); axis image; colorbar; set(gca,'FontSize',20);set(gca,'YDir','normal');
% xticks([1,123,245]); xticklabels({'-120','0','120'});
% yticks([1,87,173]); yticklabels({'-85','0','85'}); colormap(jet)
% caxis([-1500 1500]);

%%
figure;
imagesc(NoStatErrMap/100/nnz(A1)); axis image; colorbar; set(gca,'FontSize',20);set(gca,'YDir','normal');
xticks([1,123,245]); xticklabels({'-120','0','120'});
yticks([1,87,173]); yticklabels({'-85','0','85'}); colormap(jet)
caxis([-1500 1500]/nnz(A1));
%%
% 
% figure;
% imagesc(NoStatAbsErrMap/100); axis image; colorbar; set(gca,'FontSize',20);set(gca,'YDir','normal');
% xticks([1,123,245]); xticklabels({'-120','0','120'});
% yticks([1,87,173]); yticklabels({'-85','0','85'}); colormap(jet)
% caxis([-1500 1500]);
%%
% 
% figure;
% imagesc(abs(NoStatAbsErrMap-StatAbsErrMap)/100); axis image; colorbar; set(gca,'FontSize',20);set(gca,'YDir','normal');
% xticks([1,123,245]); xticklabels({'-120','0','120'});
% yticks([1,87,173]); yticklabels({'-85','0','85'}); colormap(jet)
% % caxis([-1500 1500]);

%%
figure;
imagesc((NoStatErrMap-StatErrMap)/100/nnz(A1)); axis image; colorbar; set(gca,'FontSize',20);set(gca,'YDir','normal');
xticks([1,123,245]); xticklabels({'-120','0','120'});
yticks([1,87,173]); yticklabels({'-85','0','85'}); colormap(jet)
caxis([-1000 1000]/nnz(A1));

%%
figure;
imagesc(A1/nnz(A1)); axis image; colorbar; set(gca,'FontSize',20);set(gca,'YDir','normal');
xticks([1,123,245]); xticklabels({'-120','0','120'});
yticks([1,87,173]); yticklabels({'-85','0','85'}); colormap(jet)
% caxis([-1500 1500]);


%%
figure;
PeaksLow = (A1<mean(A1(:))-std(A1(:)));
PeaksHigh = ((A1>mean(A1(:))+std(A1(:))));
PeaksHigh = boolean(PeaksHigh - bwareaopen(PeaksHigh,300));

Peaks = zeros(size(PeaksLow));
Peaks(PeaksLow) = 0.3;
Peaks(PeaksHigh) = 0.6;

Ax = A1/nnz(A1);

Peaks(Peaks==0) = Ax(Peaks==0);

imagesc(Peaks); axis image; colorbar; set(gca,'FontSize',20);set(gca,'YDir','normal');
xticks([1,123,245]); xticklabels({'-120','0','120'});
yticks([1,87,173]); yticklabels({'-85','0','85'}); colormap(jet)
caxis([0.3 0.6]);

%%
figure;
PeaksLow = (A1<mean(A1(:))-std(A1(:)));
PeaksHigh = ((A1>mean(A1(:))+std(A1(:))));
PeaksHigh = boolean(PeaksHigh - bwareaopen(PeaksHigh,300));

Peaks = zeros(size(PeaksLow));
Peaks(PeaksLow) = -0.03;
Peaks(PeaksHigh) = 0.03;


Peaks(Peaks==0) = StatErrMap(Peaks==0)/100/nnz(A1);

imagesc(Peaks); axis image; colorbar; set(gca,'FontSize',20);set(gca,'YDir','normal');
xticks([1,123,245]); xticklabels({'-120','0','120'});
yticks([1,87,173]); yticklabels({'-85','0','85'}); colormap(jet)
caxis([-0.03 0.03]);

