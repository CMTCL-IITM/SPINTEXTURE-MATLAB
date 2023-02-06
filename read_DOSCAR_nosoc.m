clear
clc
tic
%% Create figure
figure(1)
hold on
ax = gca;
%% DOS calculation
f = fopen('DOSCAR');
l1 = str2num(fgetl(f));
nions = l1(1);partial_DOS = l1(3);
l2 = str2num(fgetl(f));
vol = l2(1);basis = l2(2:4);
fgetl(f);
temp = str2double(fgetl(f));
system = fgetl(f);
l3 = str2num(fgetl(f));
Emax = l3(1);Emin = l3(2);
NEDOS = l3(end-2);Efermi = l3(end-1);
totDOS = [];
for i = 1:NEDOS
    totDOS = [totDOS;str2num(fgetl(f))];
end
ispin = 1+(min(size(totDOS))==5);
pDOS = zeros([NEDOS, 9, nions]);
for j = 1:nions
    fgetl(f);
    for i = 1:NEDOS
        l4 = str2num(fgetl(f));
        pDOS(i,:,j) = l4(2:end);
    end
end
opts.Interpreter = 'tex';
opts.Resize = 'on';
x = inputdlg({'atom selection from POSCAR','orbital selection (s=1, p_y=2, p_z=3, p_x=4, d_{xy}=5, d_{yz}=6, d_{z^2-r^2}=7, d_{xz}=8, d_{x^2-y^2}=9)','color'},...
              'Input cart', [1 50; 1 50; 1 7],{'1','1','r'},opts); 
atoms = [str2num(x{1})];orbital = [str2num(x{2})];c = x{3};
%% DOS plot
plot(totDOS(:,1)-Efermi,totDOS(:,2),'k','LineWidth',2)
plot(totDOS(:,1)-Efermi,sum(pDOS(:,orbital,atoms),[2,3]),'Color',c,'LineWidth',2)
line([0,0],[0,1000],'LineStyle','--','Color','k')
%% set the axes
ax.Box = 'on';
ax.LineWidth = 2;
ax.FontSize = 22;
ax.TickDir = 'in';
ax.TickLength = [0.01 0.01];
ax.XLim = [-15 15];
ax.YLim = [0 40];
ax.XLabel.String = 'Energy(eV)';
ax.YLabel.String = 'DOS(states/eV)';

toc
