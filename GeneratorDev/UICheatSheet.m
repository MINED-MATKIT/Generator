ObjectPlacementConstraint('overlap', 1, 1, 0, [3 7], 'gaussian', 1)

%%

ObjectPlacementConstraint('overlap', 'full', 'full', 0, 'full', 'gaussian', 1, true)


% % Callback function
% function ButtonPushed(app, event)
%     h1=figure;
%     vol3d('cdata',smooth3(rand(101,101,101))); 
%     axis tight; 
%     colormap cool; 
%     axis image;
%     view(3);
% end
% 
% % Callback function
% function Button4Pushed(app, event)
%     imageSegmenter
% end
        
%%

%app.CostFunction1PanelEnableValues([1,2,4]) = {'off'}; %Overlap

%app.CostFunction1PanelEnableValues([1,2,4]) = {'off'}; %Seperation

%app.CostFunction1PanelEnableValues([1,2,4]) = {'off'};


%%

vars = evalin('base','whos');
j = 2;
list{1} = 'Load (Workspace)';
for i = 1:length(vars)
   if  length(vars(i).size) == 3
       list{j} = vars(i).name;
       j = j+1;
   end
end
set(handles.popupmenu4,'String',list);


if strcmp(contents{get(hObject,'Value')},'Load (Workspace)') ~= 1
    GG = evalin('base',contents{get(hObject,'Value')});
    
    set(handles.slider1,'Value',max(GG(:)));
    set(handles.slider1,'Max',max(GG(:)));
    set(handles.slider1,'Min',min(GG(:)));
    set(handles.slider1,'SliderStep', [ 0.0001 , 0.01 ] );
end
%%


