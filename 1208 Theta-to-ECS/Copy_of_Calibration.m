 %clear the command window
clear all

%-------------efficiency factor on the ocean heat uptake--------------
%theta;
%---------------------------------------------------------------------

clc
%[mse_ECS,rmse_ECS,Nse_ECS,r4,r5,r6]=theta_ECS(theta);
%fprintf('theta = %f\n',theta)

theta=[0.01:0.01:1];
mse_ECS_set=[];
rmse_ECS_set=[];
Nse_ECS_set=[];

for i = theta
    [mse_ECS,rmse_ECS,Nse_ECS,r4,r5,r6]=theta_ECS(i);
    fprintf('theta = %f\n',i)
    mse_ECS_set=[mse_ECS_set mse_ECS];
    rmse_ECS_set=[rmse_ECS_set rmse_ECS];
    Nse_ECS_set=[Nse_ECS_set Nse_ECS];
    fprintf('Best fit ECS value for MSE method = %f error = %f\n',mse_ECS,r4);
    fprintf('Best fit ECS value for RMSE method = %f error = %f\n',rmse_ECS,r5);
    fprintf('Best fit ECS value for NSE method = %f error = %f\n',Nse_ECS,r6);

end

plot(theta,mse_ECS_set,theta,rmse_ECS_set,theta,Nse_ECS_set)

