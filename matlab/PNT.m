
N= 10^19;
T= 25;
T= T + 273.15;
T0= 300;

h= 6.62607015*10^(-34);% J s
%Energie fermi 
k= 1.380649*10^(-23);%bolzmann Constant J/K




ni = 1.0*10^10


Ef = k*T*log2(N/ni) + Ei

EF= Ef


P= (T0/T)*(1/((log2(1+exp(EF/(k*T))))*(1+exp(-EF/(k*T)))))
