%%Plot from modulus E and g and poision ratio v
clear all

%% 1 - in a plane (h k l) with a horizontal x-axis in direction [u v w]

% von Mikrosystemtechnik Ulrich Mescheder
%%  Elastic constants
    s11= 7.68*10^(-12); % Pa-1
    s12= -2.14*10^(-12);
    s44= 12.56*10^(-12);
%     s= 2*((s11-s12)-s44/2);

%% Crystallographic axes <100>
    x= [1 0 0];
    y= [0 1 0];
    z= [0 0 1];

%% x-axis direction in [u v w]
    uvw = [0 1 0];

%% Definition of the plane (h k l) / it normal direction  [h k l]
    hkl = [1 0 0];
%% d´Definition of the Angle range
    cdeg= 0:1:360;
    c= deg2rad(cdeg);
%% Calculus of the constants
    E= Elasticonstant(hkl, uvw,c,x,y,z, s11,s12,s44);  
%% Plots
    subplot(1,3,1)
    polarplot(E.c,E.E)
    title('Young''s modulus in GPa')
    subplot(1,3,2)
    polarplot(E.c,E.v)
    title('Poisson''s ratio')
    subplot(1,3,3)
    polarplot(E.c,E.G)
    title('Shear modulus in GPa')
    e= string(uvw);
    h= string(hkl);
   strout= strcat('uvw_' ,e(1), e(2),e(3),'_hkl_' ,h(1), h(2),h(3),'_angle_', int2str(cdeg(end)) ,'.mat');
    save(strout,'E')
    %% Functions
    
    function E= Elasticonstant(plane_hkl, xDirection_uvw,c,x,y,z, s11,s12,s44)    
        %% Euler angles a b c
        %base start x y z
        % Rot a  x1 y1 z1
        % Rot b  x2 y2 z2
        % Rot c  x3 y3 z3

        z3 = plane_hkl;
        x3 = xDirection_uvw;
        y3=cross(x3,z3);
        
        s= 2*((s11-s12)-s44/2);
        E.c=c;
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

%         %% E-Modul in direction [u v w]    
% 
%         l=[ca*cb*cc-sa*sc -ca*cb*sc-sa*cc ca*sb];
%         m=[sa*cb*cc+ca*sc -sa*cb*sc+ca*cc sa*sb];
%         n=[-sb*cc sb*sc cb];
% 
%         i=1;
%         j=2;
%         E_uvw= 10^(-9)./(s11-s*(l(i)^2*m(i)^2+l(i)^2*n(i)^2+m(i)^2*n(i)^2))%in GPa
%         v_uvw= -(2*s12+s*(l(i)^2*l(j)^2+m(i)^2*m(j)^2+n(i)^2*n(j)^2))/(s11-s*(l(i)^2*m(i)^2+l(i)^2*n(i)^2+m(i)^2*n(i)^2))
%         G_uvw = 10^(-9)./(s44+2*s*(l(i)^2*l(j)^2+m(i)^2*m(j)^2+n(i)^2*n(j)^2)) %in GPa


        %% E, v, G calculus in direction [u v w] 
        for p= 1:size(E.c,2)
            
        cc =  cos(E.c(p));
        sc =  sin(E.c(p));
        
        l=[ca*cb*cc-sa*sc -ca*cb*sc-sa*cc ca*sb];
        m=[sa*cb*cc+ca*sc -sa*cb*sc+ca*cc sa*sb];
        n=[-sb*cc sb*sc cb];

        i= 1;
        j= 2;
        E.E(p)= 10^(-9)./(s11-s*(l(i)^2*m(i)^2+l(i)^2*n(i)^2+m(i)^2*n(i)^2));%in GPa
        E.v(p)= -(2*s12+s*(l(i)^2*l(j)^2+m(i)^2*m(j)^2+n(i)^2*n(j)^2))/(2*s11-2*s*(l(i)^2*m(i)^2+l(i)^2*n(i)^2+m(i)^2*n(i)^2));
        E.G(p)= 10^(-9)./(s44+2*s*(l(i)^2*l(j)^2+m(i)^2*m(j)^2+n(i)^2*n(j)^2));%in GPa
        end
    end 
    
    
    
    
    

