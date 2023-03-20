% design the k-points in 2D kplane 
% Authors: Mayank Gupta and B.R.K.Nanda
% Contact: nandab@iitm.ac.in
clear
clc
%% read POSCAR
ps = fopen('POSCAR');
fgetl(ps);lattice_cons = str2num(fgetl(ps));
for i = 1:3
    rvec(i,:) = lattice_cons*str2num(fgetl(ps));
end
%% calculate reciprocal lattice vectors
Vol = dot(rvec(1,:),cross(rvec(2,:),rvec(3,:)));
b1 =  2*pi*cross(rvec(2,:),rvec(3,:))/Vol;
b2 =  2*pi*cross(rvec(3,:),rvec(1,:))/Vol;
b3 =  2*pi*cross(rvec(1,:),rvec(2,:))/Vol;

recip = [b1;b2;b3];
%%
opts.Interpreter = 'tex';
opts.Resize = 'on';
x = inputdlg({'origin','k-range','plane','npoints'},...
              'Input cart', [1 50; 1 50; 1 7;1 50],{'0 0 0','0.2 0.2','xy','21 21'},opts); 
origin = [str2num(x{1})];krange = [str2num(x{2})];plane = x{3};npoint = str2num(x{4});

deltax = 2*krange(1)/(npoint(1)-1);
deltay = 2*krange(2)/(npoint(2)-1);

[X, Y] = meshgrid(-krange(1):deltax:(krange(1)+deltax*0.5),-krange(2):deltay:(krange(2)+deltay*0.5));

coor = zeros(size(X(:),1),3);

if plane == 'xy'
    coor(:,1) = X(:);
    coor(:,2) = Y(:);
    coor(:,3) = zeros(length(X(:)),1);
elseif plane == 'xz'
    coor(:,1) = X(:);
    coor(:,2) = zeros(length(X(:)),1);
    coor(:,3) = Y(:);
elseif plane == 'yz'
    coor(:,1) = zeros(length(X(:)),1);
    coor(:,2) = X(:);
    coor(:,3) = Y(:);
end

% To fractional and move to the origin
kpts = [];
for j = 1: length(coor)
    kpts = [kpts;origin + sum(recip.*transpose(coor(j,:))),1];
end

save('2D_kmesh.dat','kpts','-ascii');
