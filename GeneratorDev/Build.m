A = zeros(101,101,101);




%% Object Generation - To be Implemented Later at Full - Random Rectangles for Now
rect = ones(5,9,15);

phi = round(360*rand(1));
theta = round(180*rand(1));
psi = round(360*rand(1));

%%
rect = IntrinsicRotate3D(rect, 'xyz', [phi, theta, psi]);
rect = BorderPadArray2Size(rect, size(A));

%%
alpha = zeros(101,101,101);

tic;
for i = 1:250
    
    rect = ones(5,9,15);

    phi = round(360*rand(1));
    theta = round(180*rand(1));
    psi = round(360*rand(1));
    
    rect = IntrinsicRotate3D(rect, 'xyz', [phi, theta, psi],'nearest');
    
    
    rect = BorderPadArray2Size(rect, size(alpha));

    rect = ifftshift(rect);
    
    ymap = ifftn(fftn(alpha).*conj(fftn(rect))); %%% SLOW - Fastest Possible
    
    
    ind=find(round(ymap)==0);
    
    ind=ind(randi(length(ind))); %%% SLOW
    
    [xx, yy, zz]=ind2sub(size(alpha),ind(1));
    
    rect=circshift(rect,[xx yy zz]);
    alpha(rect~=0)=rect(rect~=0);
    
    i
    
%     toc;tic;
%     vol3d('cdata',smooth3(alpha)); axis tight; colormap cool; axis image;view(3);
%     
%      view(3);
%     drawnow;
%     toc;tic;
    
end
toc;
%%
WriteToVTK(alpha,'test.vtk');
WriteToVTK(ymap,'ymaptest.vtk');



%%
alpha = zeros(101,101);

tic;
for i = 1:20
    
    rect = ones(5,11);

    phi = round(360*rand(1));
    
    rect = imrotate(rect, phi);
    
    
    rect = BorderPadArray2Size(rect, size(alpha));

    rect = ifftshift(rect);
    
    ymap = ifftn(fftn(alpha).*conj(fftn(rect))); %%% SLOW - Fastest Possible
    
    
    ind=find(round(ymap)==0);
    
    ind=ind(randi(length(ind))); %%% SLOW
    
    [xx, yy, zz]=ind2sub(size(alpha),ind(1));
    
    rect=circshift(rect,[xx yy zz]);
    alpha(rect~=0)=rect(rect~=0);
    
    i
    
end
toc;