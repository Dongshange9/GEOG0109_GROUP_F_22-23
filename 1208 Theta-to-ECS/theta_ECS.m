function [mse_ECS,rmse_ECS,Nse_ECS,r4,r5,r6] = theta_ECS(theta)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
load('Datasets/forcing_data.mat');%without the'.mat'will be fine
load('Datasets/HadCRUT5_means and uncertainties')
load('Datasets/HadCRUT5_additional fields')

DATASET=table2array(AR6ERF17502019);
Dataset_observe=table2array(HadCRUT);
col=20;%input('which column?');
F_natural=DATASET(101:270,col)*31536000;
%F_natural=DATASET(:,col)*31536000;
%---------------------------------------
%ECS=3.4;
%alpha_test=3.74/ECS*365.25*86400;

%-depth of upper layer 
h_u=100; %m,25~100
%-depth of deep layer
h_d=900; %m,500~4000
% -vertical diffusivity
kappa=1*3153.6; %m^2/year,0.2~2

[new_T_u_set,r4,r5,r6,minmse2,minrmse2,maxNse2]...
    =theta_nonamefunc(theta,F_natural,Dataset_observe,h_u,h_d,kappa);

mse_ECS=minmse2*0.1+2;
rmse_ECS=minrmse2*0.1+2;
Nse_ECS=maxNse2*0.1+2;

end

