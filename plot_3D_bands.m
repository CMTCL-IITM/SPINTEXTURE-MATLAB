%% 3D bands plot
clear
clc
tic
%% Create figure
figure1 = figure('InvertHardcopy','off','Color',[1 1 1]);
%% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');
%% import procar_matlab file and read DOSCAR 
ds = fopen('DOSCAR');
data = load('procar_matlab.dat');
%% read doscar for Efermi
for i = 1:5
    fgetl(ds);
end
l3 = str2num(fgetl(ds));
Efermi = l3(end-1);
%%
nkpts = data(1,1);
nbnds = data(1,2);
nions = data(1,3);
%% import band energy
ene = load('band_ene.dat');
eigenv = reshape(ene,[nbnds,nkpts]);
%% import kpoints
kpts = load('kpoints.dat');
%% band index for the 3D bands plotting
bandno = 85:86;

%% 2D band plotting
for j = 1:length(bandno)
eig3D = reshape(eigenv(bandno(j),:)-Efermi,[sqrt(nkpts),sqrt(nkpts)]);
surf(eig3D,'EdgeColor','k')
end

colormap turbo
colorbar
view(axes1,[45.0 12.5]);
%% set the axes
set(axes1,'FontSize',20,'LineWidth',3,'TickLength',[0.01 0.01],'TickDir','in');
set(gcf,'position',[0,0,700,800])
box(axes1,'on');
hold(axes1,'off');
xlabel('k_x');
ylabel('k_y');
zlabel('Energy(eV)')
