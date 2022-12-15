function [MSE,RMSE,NSE] = error_calculation(Modelled,Observed)
%  
%   Calculate the error matrixes
%
N=length(Observed);
MSE = sum(abs(Observed - Modelled))/N;
RMSE = sqrt(sum((Observed - Modelled).^2)/N) ;
NSE=1-(sum((Observed - Modelled) .^ 2) / N)/...
    (sum((Observed -mean(Observed)) .^ 2) / N);
end

