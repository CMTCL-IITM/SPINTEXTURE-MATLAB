%% read data from procar_matlab. Code for total and atomwise character is same.
clear
clc
tic
%% Create figure
figure1 = figure('InvertHardcopy','off','Color',[1 1 1]);
% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');
%% import procar data
data = load('procar_matlab.dat');

nkpts = data(1,1);
nbnds = data(1,2);
nions = data(1,3);

%% Set the bandindex here

bandno = 87;

%% calculate sigmax, sigmay, and sigmaz

magnet = [];
sigmax = [];
sigmay = [];
sigmaz = [];

for i = 1:nkpts
    
    kpt = (i-1)*nbnds*4+1;
    
    bnd = kpt+(bandno-1)*4;
    
    magnet = [magnet;data(bnd+1,:)];
    sigmax = [sigmax;data(bnd+2,:)];
    sigmay = [sigmay;data(bnd+3,:)];
    sigmaz = [sigmaz;data(bnd+4,:)];
end
%% import band energy
ene = load('band_ene.dat');

eigenv = reshape(ene,[nbnds,nkpts]);


%% import kpoints
kpts = load('kpoints.dat');

%% spin texture plotting
%% for s orbital orob = 1, for p orbital orob = 2,3,4, for d orbital orob = 5,6,7,8,9, for tot orob = 10;

orob = 10;

spinS = [kpts(:,1),kpts(:,2),eigenv(bandno,:)',sigmax(:,orob),sigmay(:,orob),sigmaz(:,orob)];

figure(1)
hold on
for i = 1:length(spinS)
    quiver3(spinS(i,1),spinS(i,2),spinS(i,3),spinS(i,4),spinS(i,5),spinS(i,6),0.1,'k','LineWidth',1,'MaxheadSize',1.0)
end
%% sigmaz plot
kx = reshape(kpts(:,1),[sqrt(nkpts),sqrt(nkpts)]);
ky = reshape(kpts(:,2),[sqrt(nkpts),sqrt(nkpts)]);
kz = reshape(kpts(:,3),[sqrt(nkpts),sqrt(nkpts)]);

sx = reshape(sigmax(:,end),[sqrt(nkpts),sqrt(nkpts)]);
sy = reshape(sigmay(:,end),[sqrt(nkpts),sqrt(nkpts)]);
sz = reshape(sigmaz(:,end),[sqrt(nkpts),sqrt(nkpts)]);

sx(11,11) = 0;
sy(11,11) = 0;
sz(11,11) = 0;

for i = 1:sqrt(nkpts)-1
    for j = 1:sqrt(nkpts)-1
        b = fill3([kx(i,j),kx(i,j+1),kx(i+1,j+1),kx(i+1,j)],[ky(i,j),ky(i,j+1),ky(i+1,j+1),ky(i+1,j)],[-1,-1,-1,-1],sz(i,j));
        b.EdgeColor = 'none';
    end
end
hold off

colorbar 
colormap turbo
caxis([-1,1])

%% set the axes
set(axes1,'FontSize',20,'LineWidth',3,'TickLength',[0.01 0.01]);
set(gcf,'position',[0,0,700,800])
box(axes1,'on');
hold(axes1,'off');
xlabel('S_x')
ylabel('S_y')

toc

