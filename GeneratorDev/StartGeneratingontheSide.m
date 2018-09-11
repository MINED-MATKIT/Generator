%%

tic;

alpha = zeros(51,51,51);

rect = ones(3,5,9);

phi = round(360*rand(1));
theta = round(180*rand(1));
psi = round(360*rand(1));

rect = IntrinsicRotate3D(rect, 'xyz', [phi, theta, psi],'bilinear');
rect = BorderPadArray2Size(rect, size(alpha));
rect = ifftshift(rect);

for i = 1:150
    
    ymap = ifftn(fftn(alpha).*conj(fftn(rect)));
    ind=find(round(ymap)==0);
    ind=ind(randperm(length(ind)));
    [xx, yy, zz]=ind2sub(size(alpha),ind(1));
    rect2=circshift(rect,[xx yy zz]);
    alpha(rect2~=0)=rect2(rect2~=0);
    
    i
    
end
toc;

%%
WriteToVTK(alpha,'test.vtk');
WriteToVTK(ymap,'ymaptest.vtk');


%%
[X Y Z] = meshgrid(0:20:340,0:
%%
Angles = 

%%
indData = 0;
for k = 1:length(angle)
    
    yc = imrotate(y,angle(k),'bicubic','crop');
    yc = ifftshift(yc);
    ycc = double(imdilate(yc>0,strel('disk',3,0)));
    
    for j = 1:20

        
        alpha=zeros(501,501);
        
        for i=1:100

            ymap=ifftn(fftn(alpha).*conj(fftn(ycc)));
            ind=find(round(ymap)==0);
            ind=ind(randperm(length(ind)));
            [xx, yy]=ind2sub([501,501],ind(1));
            yc2=circshift(yc,[xx yy]);
            alpha(yc2~=0)=yc2(yc2~=0);

        end
        
        indData = indData + 1;       
        Data{indData} = alpha;
        
        imagesc(alpha); axis image;
        drawnow
        
        k
        diagnostic(indData)=sum(alpha(:));
        
    end
    
end