 %clear the command window
clear all

load('Datasets/forcing_data.mat');%without the'.mat'will be fine
load('Datasets/HadCRUT5_means and uncertainties')
load('Datasets/HadCRUT5_additional fields')

%-------------efficiency factor on the ocean heat uptake--------------
theta=1;
%---------------------------------------------------------------------

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

fprintf('theta = %f\n',theta)
fprintf('Best fit ECS value for MSE method = %f error = %f\n',minmse2*0.1+2,r4);
fprintf('Best fit ECS value for RMSE method = %f error = %f\n',minrmse2*0.1+2,r5);
fprintf('Best fit ECS value for NSE method = %f error = %f\n',maxNse2*0.1+2,r6);


