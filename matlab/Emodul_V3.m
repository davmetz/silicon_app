%%Plot from young's modulus E
clear all

%% 1 - in a plane (h k l) with a horizontal x-axis in direction [u v w]

% von Mikrosystemtechnik Ulrich Mescheder
%%  Elastic constants

s11= 7.68*10^(-12); % Pa-1
s12= -2.14*10^(-12);
s44= 12.56*10^(-12);

% c11= 165.64*10^(9) % Pa
% c12= 63.94*10^(9)
% c44= 79.51*10^(9)
% 
% s11= (c11+c12)/((c11-c12)*(c11+2*c12))
% s12= -c12/((c11-c12)*(c11+2*c12))
% s44= 1/c44
s= 2*((s11-s12)-s44/2);

%% Crystallographic axes <100>
x= [1 0 0];
y= [0 1 0];
z= [0 0 1];

%% x-axis direction in [u v w]
uvw = [1 1 1];

%% Definition of the plane (h k l) / it normal direction  [h k l]
hkl = [1 1 0];

%% Direction cosines from [u v w]
    l=Direction_cosine(uvw, x);
    m=Direction_cosine(uvw, y);
    n=Direction_cosine(uvw, z);
%% E-Modul in direction [u v w]    
 
    E_uvw= 10^(-9)./(s11-s*(l^2*m^2+l^2*n^2+m^2*n^2))
    
    
    
%% Direction cosine : function
% $$cos(\theta)= \frac{\overrightarrow{u}\cdot\overrightarrow{v}}{\|\overrightarrow{u}\|\|\overrightarrow{v}\|}$$

    function cos_theta = Direction_cosine(u, v)
        cos_theta = dot(u, v)/(norm(u) * norm(v));
    end