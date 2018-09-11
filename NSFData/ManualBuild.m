%% Initialize
NewImage = zeros(173,245);
ShadeImage = zeros(173,245);

load ObjectLibrary.mat

target = FFTimfilter(double(BW), double(BW));

current = FFTimfilter(double(ans), double(ans));

%%
error = 10;
iter = 0;

for ii = 1:10

    error = 10;
    while error > 0.018

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
            Constraint2 = ObjectPlacementConstraint(true, 'spatialstats', 1, 1, [0 20], 'gaussian', 5);
            Constraints = {Constraint1,Constraint2};

            costmap = CompileCostFunctions(ShadeImage,objectshade,target,Constraints,'times');

            [NewImage, ShadeImage] = PlaceObjectwithShade(NewImage, ShadeImage, object, objectshade, costmap, 'weightedrandom');

        end

        A1 = FFTimfilter(double(BW),double(BW));
        A2 = FFTimfilter(double(ShadeImage),double(ShadeImage));

        error = norm(A1-A2)/norm(A1)

        iter = iter + 1

    end

Layers{ii} = ShadeImage;

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

%%















