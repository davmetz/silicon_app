%%Plot from young's modulus E
%% 1 - in a plane (h k l) with a horizontal x-axis in direction [u v w]

x= [1 0 0];
y= [0 1 0];
z= [0 0 1];

%% x-axis direction in [u v w]
uvw = [1 0 0];
u= uvw(1);
v= uvw(2);
w= uvw(3);

%% Definition of the plane (h k l) / it normal direction  [h k l]
hkl = [1 0 1];
h= hkl(1);
k= hkl(2);
l= hkl(3);

%% Euler angles a b c

% hkl_xy vector projection of hkl on xy-plane
    hkl_xy= [dot(hkl, x)/norm(x)^2 dot(hkl, y)/norm(y)^2 0];
% N vector >> Rotation of hkl_xy of 90degrees
    rotZ_90degree = [0 -1 0;1 0 0;0 0 1];
    N= [rotZ_90degree*hkl_xy']';

% b angle >> angle between hkl and z
    b = AngleBtwVectors(hkl, z)
    rad2deg(b)
% a angle >> angle between N and x
    a = AngleBtwVectors(N, x)
    rad2deg(a)
% c angle >> angle between uvw and N
    c = AngleBtwVectors(uvw, N)
    rad2deg(c)
    
    
ca =  cos(a);
cb =  cos(b);
cc =  cos(c);

sa =  sin(a);
sb =  sin(b);
sc =  sin(c);
   

l=[cc*ca-cb*sa*sc cc*sa+cb*ca*sc sc*sb]
m=[-sc*ca-cb*sa*cc -sc*sa+cb*ca*cc cc*sb]
n=[sb*sa -sb*ca cb]

s11= 7.68*10^(-12);
s12= -2.14*10^(-12);
s44= 12.56*10^(-12);

% c11= 165.5*10^(9)
% c12= 63.9*10^(9)
% c44= 79.5*10^(9)
% 
% s11= (c11+c12)/((c11-c12)*(c11+2*c12))
% s12= -c12/((c11-c12)*(c11+2*c12))
% s44= 1/c44
stop

%% E-Modul

Plane = [1 0 0];
X_axis_direction =[1 1 0]; % compared to the direction <1 0 0>
Y_axis_direction =[1 0 0]; % compared to the direction <0 0 0>

theta= [0:pi/200:pi]
phi= [0:2*pi/200:2*pi]
%  [theta,phi]=meshgrid(theta,phi);
[l1,m1,n1]= sph2cart(theta, phi,1)
%  surf(l1,m1,n1)
%  stop
for i= 1:3
E(i)= 10^(-9)./(s11-2*((s11-s12)-0.5*s44)*(l(i)^2*m(i)^2+l(i)^2*n(i)^2+m(i)^2*n(i)^2))
end
stop
rho = E
max(E)
min(E)

[theta,phi]=meshgrid(theta,phi);
[x,y,z]= sph2cart(theta, phi,rho)
surf(x,y,z)
stop




l1=cos([-pi/4:pi/2/200:pi/4])
m1=cos([pi/4:pi/2/200:3*pi/4])
n1=cos(pi/2)

l1=cos([0:2*pi/200:2*pi])
m1=cos([0:2*pi/200:2*pi])
n1=cos(pi/2)

E= 10^(-9)./(s11-2*((s11-s12)-0.5*s44)*(l1.^2.*m1.^2+l1.^2*n1.^2+m1.^2*n1.^2))

h=polar([0:pi/2/200:pi/2],E)


stop
l1=cos([-pi/4:pi/2/200:pi/4])
m1=cos([pi/4:pi/2/200:3*pi/4])
n1=cos(pi/2)

l2=cos([-pi/4:pi/2/200:pi/4])
m2=cos([pi/4:pi/2/200:3*pi/4])
n2=cos(pi/2)

E= 10^(-9)./(s11-2*((s11-s12)-0.5*s44)*(l1.^2.*m1.^2+l1.^2*n1.^2+m1.^2*n1.^2))
G= 10^(-9)./(s44-4*((s11-s12)-0.5*s44)*(l1.^2.*l2.^2+m1.^2*m2.^2+n1.^2*n2.^2))

h=polar([0:pi/2/200:pi/2],E)
hold on 
polar([0:pi/2/200:pi/2],G)
axis([0,200,0,200])

