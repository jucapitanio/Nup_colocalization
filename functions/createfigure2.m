function createfigure2(X1, Y1, Z1, S1, C1, Vertices1, VertexNormals1, Faces1)
%CREATEFIGURE2(X1, Y1, Z1, S1, C1, VERTICES1, VERTEXNORMALS1, FACES1)
%  X1:  scatter3 x
%  Y1:  scatter3 y
%  Z1:  scatter3 z
%  S1:  scatter3 s
%  C1:  scatter3 c
%  VERTICES1:  patch vertices
%  VERTEXNORMALS1:  patch vertexnormals
%  FACES1:  patch faces

% USE THIS TO CREATE A FIG WITH NUCLEI MASK AND SPOTS

%  Auto-generated by MATLAB on 01-Dec-2015 20:02:42

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,'Color',[0 0 0],...
    'ZColor',[0.501960813999176 0.501960813999176 0.501960813999176],...
    'YColor',[0.501960813999176 0.501960813999176 0.501960813999176],...
    'XColor',[0.501960813999176 0.501960813999176 0.501960813999176],...
    'DataAspectRatio',[1 1 0.45]);
view(axes1,[-70.5 40]);
box(axes1,'on');
hold(axes1,'on');

% Create scatter3
scatter3(X1,Y1,Z1,S1,C1,'MarkerEdgeColor',[1 0 0],'Marker','.');

% Create patch
patch('Parent',axes1,'FaceLighting','gouraud','FaceAlpha',0.7,...
    'Vertices',Vertices1,...
    'VertexNormals',VertexNormals1,...
    'Faces',Faces1,...
    'FaceColor',[0 0 1],...
    'EdgeColor','none');

% Create light
light('Parent',axes1,...
    'Position',[244.817067307074 -733.002902326085 1235.67614387691],...
    'Style','local');

