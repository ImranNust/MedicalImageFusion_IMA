function Retim = enhnc(x)

%% Equation 1 in the article
[m n]=size(x);
xx=sum(x(:))/(m*n); 

%% Equation 2 in the article
xx0 = (x - min(x(:)))*exp(xx);
xx1 = max(x(:))- min(x(:)); 
Retim=xx0/xx1;