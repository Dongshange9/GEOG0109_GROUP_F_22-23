function [T_u_set,r1,r2,r3,max_mse,max_rmse,max_Nse] = ...
    nonamefunc(F_natural,Dataset_observe,h_u,h_d,kappa)
%
rho_water=1027;   % kg/(m^3)
c_p=4218; %J/kg/K

C_u=rho_water*c_p*h_u;

C_d=rho_water*c_p*h_d;
gamma=2*kappa*c_p*rho_water/(h_u+h_d);

index=[];
error_mse=[];
error_rmse=[];
error_Nse=[];

for i = 1:57
    %fprintf('%d',ECS);
    
    ECS=2.0+0.1*i;
    index(i)=ECS;
    alpha_test=3.74/ECS*365.25*86400;
    
    T_u=0;
    T_d=0;

    T_u_set=[];
    for j = 1:length(F_natural)
        dTu_dt=(F_natural(j)-alpha_test*T_u-gamma*(T_u-T_d))/C_u;
        dTd_dt=gamma*(T_u-T_d)/C_d;

        T_u_set(j)=T_u;

        T_u=T_u+dTu_dt;
        T_d=T_d+dTd_dt;
    end

    [er1,er2,er3]=error_calculation(transpose(T_u_set),...
    Dataset_observe(1:170,2)-Dataset_observe(1,2));
    
    error_mse(i)=er1;
    error_rmse(i)=er2;
    error_Nse(i)=er3;
    
end

[r1,max_mse] = min(error_mse);
[r2,max_rmse] = min(error_rmse);
[r3,max_Nse] = max(error_Nse);

end

