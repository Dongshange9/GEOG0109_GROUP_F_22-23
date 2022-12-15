 %clear the command window
clear all
load('Datasets\forcing_data.mat');%without the'.mat'will be fine
load('Datasets\HadCRUT5_means and uncertainties')
load('Datasets\HadCRUT5_additional fields')
load('Datasets/pc05')%seems / & \ both ok for the file
load('Datasets\pc95')

%-------------efficiency factor on the ocean heat uptake--------------
theta=1;
%---------------------------------------------------------------------

ECS=4.2;

%---------------------------------------------------------------------
%col=20 means we will see the 'total' column
%col_o=2 is also total observed column
col=20;%input('which column?');
col_o=2;

DATASET=table2array(AR6ERF17502019);%import forcing_data.mat
Dataset_observe=table2array(HadCRUT);%import HadCRUT5_means and uncertainties

Data_lower=table2array(AR6ERF17502019pc05);
Data_upper=table2array(AR6ERF17502019pc95);
%---------------------------------------

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
%------------------------------------

T_u_set=basinbox_theta(DATASET,col,alpha_test,gamma,C_u,C_d,theta);
T_u_lower=basinbox_theta(Data_lower,col,alpha_test,gamma,C_u,C_d,theta);
T_u_upper=basinbox_theta(Data_upper,col,alpha_test,gamma,C_u,C_d,theta);

%-------------plotting--------------
dy=T_u_lower(101:270);
uy=T_u_upper(101:270);

x=1850:2019;



l2=plot(1850:2019,Dataset_observe(1:170,col_o)-Dataset_observe(1,col_o),...
    'rx','LineWidth',0.6);
hold on

l4=plot(1850:2019,T_u_set(101:270),...
    'color',[182,124,79]./255,'LineWidth',1.2);

hold on
plot([x',x'],[T_u_lower(101:270)',T_u_upper(101:270)'],...
    'Color',[82,124,179]./255,'LineWidth',0.8,'LineStyle','--');
fill([x,x(end:-1:1)],[uy,dy(end:-1:1)],...
    [82,124,179]./255,'EdgeColor','none','FaceAlpha',.2);

legend([l4,l2],{'Simulated human & natural','Observed Value'});

different=transpose(T_u_set(101:270))...
    -Dataset_observe(1:170,col_o)+Dataset_observe(1,col_o);
error=0;
for i=1:170
    error=error+different(i)^2;
end

error=sqrt(error/170);
fprintf('\nRMSE error for %f ',ECS);
fprintf('is %f',error);
fprintf('\nNow the ocean heat uptake is theta = %f \n',theta)


[er1,er2,er3]=error_calculation(transpose(T_u_set(101:270)),...
    Dataset_observe(1:170,col_o)-Dataset_observe(1,col_o));
