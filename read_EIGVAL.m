%% read EIGVAL file and plot the band structure.
% Authors: Mayank Gupta and B.R.K.Nanda
% Contact: nandab@iitm.ac.in
clear
clc
tic
% Create figure
figure1 = figure('InvertHardcopy','off','Color',[1 1 1]);
% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');
%% read vasp outputs
f = fopen('EIGENVAL');
ps = fopen('POSCAR');
ds = fopen('DOSCAR');
kp = fopen('KPOINTS');
%% read doscar for Efermi
for i = 1:5
    fgetl(ds);
end
l3 = str2num(fgetl(ds));
Efermi = l3(end-1);
%% read kpoints
fgetl(kp);kp1 = str2num(fgetl(kp));
%% read POSCAR
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
%% band plots
for i =1:5
    fgetl(f);
end
d1 = str2num(fgetl(f));
nions = d1(1);nkpts = d1(2);nbnds = d1(3);
bnd_ene = [];
kpoints =[];
for l =1:nkpts
    fgetl(f);
    kpoints = [kpoints;str2num(fgetl(f))];
    for k = 1:nbnds
        bnd_ene = [bnd_ene;str2num(fgetl(f))];
    end
end
bnd_ene1 = reshape(bnd_ene(:,2),[nbnds,nkpts]);

%% k-lengh calculation
kpts = [];
for j = 1: length(kpoints)
    kpts = [kpts;sum(recip.*transpose(kpoints(j,1:3)))];
end
s = zeros(1,size(kpts,1));
for i = 1:size(kpts,1)-1
    d = sqrt(sum((kpts(i,:)-kpts(i+1,:)).^2));
    s(i+1) = s(i) + d;
end
hskpt = s(1:kp1:end);
%%
plot(s,bnd_ene1-Efermi,'b','Linewidth', 2,'Parent',axes1)
line([0,s(end)],[0,0],'LineStyle','--','Color','r')
for i = 1:length(hskpt)
    line([hskpt(i),hskpt(i)],[-10,10],'LineStyle','--','Color','b')
end
%% set the axes
set(axes1,'FontSize',20,'LineWidth',3,'TickLength',[0.001 0.001]);
set(gcf,'position',[0,0,700,800])
xlim(axes1,[0 s(end)]);
ylim(axes1,[-5 5]);
zlim(axes1,[-1 1]);
box(axes1,'on');
hold(axes1,'off');
ylabel('Energy(eV)')

toc
