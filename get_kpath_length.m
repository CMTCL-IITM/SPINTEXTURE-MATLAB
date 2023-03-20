% Design the k-path 
% Authors: Mayank Gupta and B.R.K.Nanda
% Contact: nandab@iitm.ac.in
%%
clear
clc

ps = fopen('POSCAR');
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

%% load k-points in reciprocal lattice

klist = load('kpoints.dat');

%% k-lengh calculation
kpts = [];
for j = 1: length(klist)
    kpts = [kpts;sum(recip.*transpose(klist(j,:)))];
end

s = zeros(1,size(kpts,1));

for i = 1:size(kpts,1)-1
    d = sqrt(sum((kpts(i,:)-kpts(i+1,:)).^2));
    s(i+1) = s(i) + d;
end

output = [s'];

save('klength.dat','output','-ascii');
