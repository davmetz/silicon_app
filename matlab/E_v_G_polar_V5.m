%% Calcul and Plots of elastic constants $E$, $G$, $v$ and piezoresitive coefficients $\pi_{L}$, $\pi_{T}$
% Young's modulus $E_{[uvw]}$
% Shear Modulus $G_{[uvw](hkl)}$
% Poisson's ratio $v_{[uvw](hkl)}$
% longitudinal coefficient $\pi_{L}=\pi_{[uvw]}$$
% transversal coefficient $\pi_{T}$
% $\pi=\pi_{[uvw]}$
%% Initiatisation
clear all
close gcf
global C R % global constant: C , global results variable: R
%%  Material Coefficients
% Elastic coefficients in Pa^-1
C.s11 =   7.68    *10^(-12);
C.s12 =   -2.14   *10^(-12);
C.s44 =   12.56   *10^(-12);
% Piezoresistive coefficients for p-type in Pa^-1
C.pi11(1) =  6.6    *10^(-11);
C.pi12(1) =  -1.1   *10^(-11);
C.pi44(1) =  138.1   *10^(-11);
% Piezoresistive coefficients for n-type in Pa^-1
C.pi11(2) =  -102.2  *10^(-11);
C.pi12(2) =  53.4    *10^(-11);
C.pi44(2) =  -13.6   *10^(-11);
%% Crystallographic axes <100>
x(1,:)= [1 0 0];
x(2,:)= [0 1 0];
x(3,:)= [0 0 1];
%% choose [uvw] in the plane (hkl)
% x-axis direction in [u v w]
uvw = [-1 1 0];
% Definition of the plane (h k l) / it normal direction  [h k l]
hkl = [1 1 0];
%% Definition of the Angle range
cdeg= 0:1:180;
c= deg2rad(cdeg);
%% Calculus of the constants
E= Elasticonstant(hkl, uvw,c,x(1,:),x(2,:),x(3,:));
Results= [E.c' E.E' E.v' E.G',E.piL_p',E.piT_p',E.piL_n',E.piT_n'];
c_E_v_G_piL_piT = Results(1,:)
%% Plots
hold on
subplot(2,3,1)
polarplot(E.c,E.E)
title('Young''s modulus in GPa')
subplot(2,3,2)
polarplot(E.c,E.v)
title('Poisson''s ratio')
subplot(2,3,3)
polarplot(E.c,E.G)
title('Shear modulus in GPa')
subplot(2,3,4)
polarplot(E.c,E.piL_p)
title('PiLT_p')
hold on
subplot(2,3,4)
polarplot(E.c,E.piT_p)
title('PiLT_p')
subplot(2,3,5)
polarplot(E.c,E.piL_n)
title('PiLT_n')
hold on
subplot(2,3,5)
polarplot(E.c,E.piT_n)
title('PiLT_n')
%% Save results
e= string(uvw);
h= string(hkl);
strout= strcat('uvw_' ,e(1), e(2),e(3),'_hkl_' ,h(1), h(2),h(3),'_angle_', int2str(cdeg(end)) ,'.mat');
save(strout,'Results','E')
%% Function
function E= Elasticonstant(plane_hkl, xDirection_uvw,c_angle,x,y,z)    
%% Euler angles a b c
%base start x y z
% Rot a  x1 y1 z1
% Rot b  x2 y2 z2
% Rot c  x3 y3 z3
global C
z3 = plane_hkl;
x3 = xDirection_uvw;
y3=cross(x3,z3);
if dot(x3,z3)~= 0
    msgbox('Choose perpendicular vector');
end


E.c=c_angle;

% $\overrightarrow{x1}$ projection of $\overrightarrow{z3}$ on xy-plane
x1= [dot(z3, x)/norm(x)^2 dot(z3, y)/norm(y)^2 0];
% N vector or y1 vector >> Rotation of x1 of 90degrees
rotZ_90degree = [0 -1 0;1 0 0;0 0 1];
N= [rotZ_90degree*x1']';   

% a angle >> angle between N and y
a = AngleBtwVectors(N, y);
alpha = rad2deg(a);
% b angle >> angle between z3 and z
b = AngleBtwVectors(z3, z);
beta = rad2deg(b);
% c angle >> angle between y3 and N
c = AngleBtwVectors(y3, N);
gamma = rad2deg(c);
E.c = E.c+c;
% cosinus of a b c    
ca =  cos(a);
cb =  cos(b);
cc =  cos(c);
% sinus of a b c
sa =  sin(a);
sb =  sin(b);
sc =  sin(c);
%% E, v, G calculus in direction [u v w] 

for p= 1:size(E.c,2)
    cc =  cos(E.c(p));
    sc =  sin(E.c(p));
    
    
    l=[ca*cb*cc-sa*sc -ca*cb*sc-sa*cc ca*sb]';
    m=[sa*cb*cc+ca*sc -sa*cb*sc+ca*cc sa*sb]';
    n=[-sb*cc sb*sc cb]';
    i= 1;
    j= 2;
    
    s= 2*((C.s11-C.s12)-C.s44/2);
    E.E(p)= 10^(-9)./...
        (C.s11-s*(l(i)^2*m(i)^2+l(i)^2*n(i)^2+m(i)^2*n(i)^2));%in GPa
    E.v(p)= -(2*C.s12+s*(l(i)^2*l(j)^2+m(i)^2*m(j)^2+n(i)^2*n(j)^2))/...
        (2*C.s11-2*s*(l(i)^2*m(i)^2+l(i)^2*n(i)^2+m(i)^2*n(i)^2));
    E.G(p)= 10^(-9)./...
        (C.s44+2*s*(l(i)^2*l(j)^2+m(i)^2*m(j)^2+n(i)^2*n(j)^2));%in GPa
    i= 1;
    j= 2;
    t= 1;
    E.piL_p(p)= (C.pi11(t)-2*(C.pi11(t)-C.pi12(t)-C.pi44(t))*...
        (l(i)^2*m(i)^2+l(i)^2*n(i)^2+m(i)^2*n(i)^2))/10^(-11);
    E.piT_p(p)= (C.pi12(t)+(C.pi11(t)-C.pi12(t)-C.pi44(t))*...
        (l(i)^2*l(j)^2+m(i)^2*m(j)^2+n(i)^2*n(j)^2))/10^(-11);
    t= 2;
    E.piL_n(p)= (C.pi11(t)-2*(C.pi11(t)-C.pi12(t)-C.pi44(t))*...
        (l(i)^2*m(i)^2+l(i)^2*n(i)^2+m(i)^2*n(i)^2))/10^(-11);
    E.piT_n(p)= (C.pi12(t)+(C.pi11(t)-C.pi12(t)-C.pi44(t))*...
        (l(i)^2*l(j)^2+m(i)^2*m(j)^2+n(i)^2*n(j)^2))/10^(-11);
    
end
E.c=c_angle;
end 
    


