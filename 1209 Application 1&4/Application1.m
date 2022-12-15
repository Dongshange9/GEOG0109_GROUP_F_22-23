%clear the command window
clear
clc
%load data file
load('Datasets\forcing_data.mat');%without the'.mat'will be fine
load('Datasets\HadCRUT5_means and uncertainties')
load('Datasets\HadCRUT5_additional fields')
load('Datasets/pc05')%seems / & \ both ok for the file
load('Datasets\pc95')
%%---------------parameter---------------
%---------------------------------------------------------------------
%climate sensitivity
ECS=4.2;

%---------------------------------------------------------------------
%heat intake efficiency
theta=1;

%---------------------------------------------------------------------

alpha_test=3.74/ECS*365.25*86400;

%-density of sea water
rho_water=1027;   % kg/(m^3)

%-specific heat capacity of water
c_p=4218; %J/kg/K

%-depth of upper layer 
h_u=100; %m
%-depth of deep layer
h_d=900; %m

%-thermal inertia:C=rho*c_p*h
%-of upper layer 
C_u=rho_water*c_p*h_u;
%-of deep layer
C_d=rho_water*c_p*h_d;

%-climate feedback parameter
%alpha=-3.74/ECS

% -vertical diffusivity
kappa=3153.6; %m^2/year

%W*m(-2)*K*(-1)
gamma=2*kappa*c_p*rho_water/(h_u+h_d);
%---------------------------------------------------------------------
%import data
DATASET=table2array(AR6ERF17502019);%import forcing_data.mat
Dataset_observe=table2array(HadCRUT);%import HadCRUT5_means and uncertainties

Data_lower=table2array(AR6ERF17502019pc05);
Data_upper=table2array(AR6ERF17502019pc95);

%'total' column in simulated dataset
col_total=20;

%'total natural' column in simulated dataset
col_total_natural=19;

%'greenhouse gas' in simulated dataset
DATASET_GHG=DATASET(:,2)+DATASET(:,3)+DATASET(:,4)+DATASET(:,5);
Data_lower_GHG=Data_lower(:,2)+Data_lower(:,3)+Data_lower(:,4)+Data_lower(:,5);
Data_upper_GHG=Data_upper(:,2)+Data_upper(:,3)+Data_upper(:,4)+Data_upper(:,5);

%'aerosols' column in simulated dataset
col_aerosols=16;

%'total' column in observed dataset
col_observed=2;

%---------------------------------------------------------------------
%temperature change by total forcing
T_u_set=basinbox_theta(DATASET,col_total,alpha_test,gamma,C_u,C_d,theta);
T_u_lower=basinbox_theta(Data_lower,col_total,alpha_test,gamma,C_u,C_d,theta);
T_u_upper=basinbox_theta(Data_upper,col_total,alpha_test,gamma,C_u,C_d,theta);

%temperature change by total natural forcing
T_u_natural=basinbox_theta(DATASET,col_total_natural, ...
    alpha_test,gamma,C_u,C_d,theta);
T_u_lower_natural=basinbox_theta(Data_lower,col_total_natural, ...
    alpha_test,gamma,C_u,C_d,theta);
T_u_upper_natural=basinbox_theta(Data_upper,col_total_natural, ...
    alpha_test,gamma,C_u,C_d,theta);

%temperature change by GHG forcing
T_u_GHG=basinbox_theta(DATASET_GHG,1,alpha_test,gamma,C_u,C_d,theta);
T_u_lower_GHG=basinbox_theta(Data_lower_GHG,1, ...
    alpha_test,gamma,C_u,C_d,theta);
T_u_upper_GHG=basinbox_theta(Data_upper_GHG,1, ...
    alpha_test,gamma,C_u,C_d,theta);

%temperature change by total natural forcing
T_u_aerosols=basinbox_theta(DATASET,col_aerosols, ...
    alpha_test,gamma,C_u,C_d,theta);
T_u_lower_aerosols=basinbox_theta(Data_lower,col_aerosols, ...
    alpha_test,gamma,C_u,C_d,theta);
T_u_upper_aerosols=basinbox_theta(Data_upper,col_aerosols, ...
    alpha_test,gamma,C_u,C_d,theta);

%-------------plotting--------------
dy=T_u_lower(101:270);
uy=T_u_upper(101:270);

dy_natural=T_u_lower_natural(101:270);
uy_natural=T_u_upper_natural(101:270);

dy_GHG=T_u_lower_GHG(101:270);
uy_GHG=T_u_upper_GHG(101:270);

dy_aerosols=T_u_lower_aerosols(101:270);
uy_aerosols=T_u_upper_aerosols(101:270);
%---------------------------------------------------------------------
x=1850:2019;
%---------------------------------------------------------------------
%observed data
l1=plot(1850:2019,Dataset_observe(1:170,col_observed)-Dataset_observe(1,col_observed),...
    'rx','LineWidth',0.6);
hold on
%---------------------------------------------------------------------
%simulated human & natural
l2=plot(1850:2019,T_u_set(101:270),...
    'color',[0,70,222]./255,'LineWidth',3);
hold on
%confidence interval
plot([x',x'],[T_u_lower(101:270)',T_u_upper(101:270)'],...
    'Color',[82,124,179]./255,'LineWidth',0.8,'LineStyle','--');
fill([x,x(end:-1:1)],[uy,dy(end:-1:1)],...
    [82,124,179]./255,'EdgeColor','none','FaceAlpha',.2);
%---------------------------------------------------------------------
%simulated natural
l3=plot(1850:2019,T_u_natural(101:270),...
    'color',[54,195,201]./255,'LineWidth',1);
hold on
%confidence interval
plot([x',x'],[T_u_lower_natural(101:270)',T_u_upper_natural(101:270)'],...
    'Color',[82,124,179]./255,'LineWidth',0.8,'LineStyle','--');
fill([x,x(end:-1:1)],[uy_natural,dy_natural(end:-1:1)],...
    [219,249,160]./255,'EdgeColor','none','FaceAlpha',.2);
%---------------------------------------------------------------------
%simulated GHG
l4=plot(1850:2019,T_u_GHG(101:270),...
    'color',[252,41,30]./255,'LineWidth',1);
hold on
%confidence interval
plot([x',x'],[T_u_lower_GHG(101:270)',T_u_upper_GHG(101:270)'],...
    'Color',[82,124,179]./255,'LineWidth',0.8,'LineStyle','--');
fill([x,x(end:-1:1)],[uy_GHG,dy_GHG(end:-1:1)],...
    [255,210,210]./255,'EdgeColor','none','FaceAlpha',.2);
%---------------------------------------------------------------------
%simulated aerosols
l5=plot(1850:2019,T_u_aerosols(101:270),...
    'color',[255,170,50]./255,'LineWidth',1);
hold on
%confidence interval
plot([x',x'],[T_u_lower_aerosols(101:270)',T_u_upper_aerosols(101:270)'],...
    'Color',[82,124,179]./255,'LineWidth',0.8,'LineStyle','--');
fill([x,x(end:-1:1)],[uy_aerosols,dy_aerosols(end:-1:1)],...
    [237,177,131]./255,'EdgeColor','none','FaceAlpha',.2);
%---------------------------------------------------------------------
%legend of plot
legend([l1,l2,l3,l4,l5],{'Observed value','Simulated human & natural', ...
    'Simulated natural','Simulated GHG','Simulated aerosols'});

