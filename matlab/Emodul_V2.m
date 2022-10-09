%%Plot from young's modulus E
clear all

%% 1 - in a plane (h k l) with a horizontal x-axis in direction [u v w]

% von Mikrosystemtechnik Ulrich Mescheder
%%  Elastic constants
    s11= 7.68*10^(-12); % Pa-1
    s12= -2.14*10^(-12);
    s44= 12.56*10^(-12);
    s= 2*((s11-s12)-s44/2);

%% Crystallographic axes <100>
    x= [1 0 0];
    y= [0 1 0];
    z= [0 0 1];

%% x-axis direction in [u v w]
    uvw = [0 1 0];

%% Definition of the plane (h k l) / it normal direction  [h k l]
    hkl = [1 0 0];

   
%     yyaxis('left');
     polarplot(c,E)
%     yyaxis('right');
    polarplot(c,v)
    polarplot(c,G)
%     rad2deg(b)
%     rad2deg(a)
%  
    
    
    function [E,v,G,c]= Elasticonstant(plane_hkl, xDirection_uvw)    
        %% Euler angles a b c
        %base start x y z
        % Rot a  x1 y1 z1
        % Rot b  x2 y2 z2
        % Rot c  x3 y3 z3

        z3 = plane_hkl;
        x3 = xDirection_uvw;
        y3=cross(x3,z3);
        % $\overrightarrow{x1}$ projection of $\overrightarrow{z3}$ on xy-plane
            x1= [dot(z3, x)/norm(x)^2 dot(z3, y)/norm(y)^2 0];
        % N vector or y1 vector >> Rotation of x1 of 90degrees
            rotZ_90degree = [0 -1 0;1 0 0;0 0 1];
            N= [rotZ_90degree*x1']';   

        % a angle >> angle between N and y
            a = AngleBtwVectors(N, y);
        % b angle >> angle between z3 and z
            b = AngleBtwVectors(z3, z);
        % c angle >> angle between y3 and N
            c = AngleBtwVectors(y3, N);

        % cosinus of a b c    
            ca =  cos(a);
            cb =  cos(b);
            cc =  cos(c);
        % sinus of a b c
            sa =  sin(a);
            sb =  sin(b);
            sc =  sin(c);

        %% E-Modul in direction [u v w]    

        l=[ca*cb*cc-sa*sc -ca*cb*sc-sa*cc ca*sb];
        m=[sa*cb*cc+ca*sc -sa*cb*sc+ca*cc sa*sb];
        n=[-sb*cc sb*sc cb];

        i=1;
        j=2;
        E_uvw= 10^(-9)./(s11-s*(l(i)^2*m(i)^2+l(i)^2*n(i)^2+m(i)^2*n(i)^2))%in GPa
        v_uvw= -(2*s12+s*(l(i)^2*l(j)^2+m(i)^2*m(j)^2+n(i)^2*n(j)^2))/(s11-s*(l(i)^2*m(i)^2+l(i)^2*n(i)^2+m(i)^2*n(i)^2))
        G_uvw = 10^(-9)./(s44+2*s*(l(i)^2*l(j)^2+m(i)^2*m(j)^2+n(i)^2*n(j)^2)) %in GPa


        %% E-Modul in direction [u v w]  
        c= 0:1:90;
        c= deg2rad(c);
        for p= 1:size(c,2)

        cc =  cos(c(p));
        sc =  sin(c(p));
        l=[ca*cb*cc-sa*sc -ca*cb*sc-sa*cc ca*sb];
        m=[sa*cb*cc+ca*sc -sa*cb*sc+ca*cc sa*sb];
        n=[-sb*cc sb*sc cb];

        i= 1;
        j= 2;
        E(p)= 10^(-9)./(s11-s*(l(i)^2*m(i)^2+l(i)^2*n(i)^2+m(i)^2*n(i)^2));%in GPa
        v(p)= -(2*s12+s*(l(i)^2*l(j)^2+m(i)^2*m(j)^2+n(i)^2*n(j)^2))/(s11-s*(l(i)^2*m(i)^2+l(i)^2*n(i)^2+m(i)^2*n(i)^2));
        G(p)= 10^(-9)./(s44+2*s*(l(i)^2*l(j)^2+m(i)^2*m(j)^2+n(i)^2*n(j)^2));%in GPa
        end
    end 
    
    
    
    
    

