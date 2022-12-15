function [msg] = basinbox_theta(DATASET,col,alpha_test,gamma,C_u,C_d,theta)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明

T_u=0;
T_d=0;
F_natural=DATASET(:,col)*31536000;

T_u_set=[];
for i = 1:length(F_natural)
    dTu_dt=theta*((F_natural(i)-alpha_test*T_u)-gamma*(T_u-T_d))/C_u;
    dTd_dt=gamma*(T_u-T_d)/C_d;

    T_u_set(i)=T_u;

    T_u=T_u+dTu_dt;
    T_d=T_d+dTd_dt;
end

msg=T_u_set;

end

