%% read PROCAR file.

clear
clc
%%
tic
f = fopen('PROCAR');

kpoints = [];

fgetl(f);
d1 = fgetl(f);
nkpts = str2double(d1(15:21));
nbnds = str2double(d1(40:46));
nions = str2double(d1(65:end));

frewind(f);fgetl(f)
%%
data = [nkpts,nbnds,nions,0,0,0,0,0,0,0];
bnd_ene = [];
for l =1:nkpts
    for m = 1:3
        if m ==3
            kp1 = fgetl(f);
            kpoints = [kpoints;str2double(kp1(20:30)),str2double(kp1(31:41)),str2double(kp1(42:52))];
        else
            fgetl(f);
        end
    end
    for k = 1:nbnds
        for i=1:4
            if i ==2
                ene = fgetl(f);
                bnd_ene = [bnd_ene;str2double(ene(21:30))];
            else
                fgetl(f);
            end
        end
        for j = 1:4
            for i=1:nions
                fgetl(f);
            end     
            d2 = fgetl(f);
            data = [data;str2num(d2(4:end))];
        end
    end
end
save('procar_matlab.dat','data','-ascii')
save('kpoints.dat','kpoints','-ascii')
save('band_ene.dat','bnd_ene','-ascii')
toc
