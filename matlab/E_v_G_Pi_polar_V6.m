%% Compute elastic constants $E$, $G$, $v$ and piezoresitive coefficients $\pi_{L}$, $\pi_{T}$ in a (hkl)-plane from a [uvw]-direction
%% Initiatisation
clear all
close all
% global constant: C , global results variable: R
global C R

% Elastic coefficients s_{11}, s_{12}, s_{44} in Pa^-1 
C.s =  [7.68 -2.14 12.56] *10^(-12);

% Piezoresitive Coefficients pi_{11}, pi_{12}, pi_{44} for p-type in Pa^-1
C.pi(1,:) =  [6.6 -1.1 138.1] *10^(-11);

% Piezoresitive Coefficients pi_{11}, pi_{12}, pi_{44} for n-type in Pa^-1
C.pi(2,:) =  [-102.2 53.4 -13.6] *10^(-11);

% Assignment of the basis x_i noted x
x(1,:)= [1 0 0]; % Crystallographic axes <100>
x(2,:)= [0 1 0];
x(3,:)= [0 0 1];

% Assignment of direction [uvw] and [hkl] 

uvw = [0 1 1]; % direction [uvw] to the x-axis in the generated plots  (here modify)
hkl = [1 0 0]; % plane (hkl) is the plane of the generated plots (here modify)

if dot(uvw,hkl)~= 0 % test if [hkl] and [uvw] are perpendicular
    msgbox('Choose perpendicular directions [hkl] and [uvw]');
end

% Determination of the basis x_i' with x_1' in [uvw] and x_3'$ in [hkl]
x_prime(1,:)= uvw;
x_prime(2,:)= cross(uvw,hkl);
x_prime(3,:)= hkl;

%  Assignment of the angle range in the plane (hkl) (for the plots)
%  note: in the generated plots, the direction [uvw] correspond to the direction for angle =  0 
angle_hkl_deg= 0:1:180; % (here modify)

%% Compute constants and coefficients
%
E= Elasticonstant(x, x_prime, angle_hkl_deg);
R= [E.angle_hkl_rad' E.angle_hkl_deg' E.E' E.v' E.G',[E.piL(1,:)*10^(11)]',[E.piT(1,:)*10^(11)]',[E.piL(2,:)*10^(11)]',[E.piT(2,:)*10^(11)]',[E.piL(1,:)*0.3*10^(11)]',[E.piT(1,:)*0.3*10^(11)]'];
%% Show values for the direction [uvw]
%
Results_uvw = R(1,:)
%% Save results
%
e= string(uvw);
h= string(hkl);
strout= strcat('uvw_' ,e(1), e(2),e(3),'_hkl_' ,h(1), h(2),h(3),'_angle_', int2str(E.angle_hkl_deg(end)));
save(strcat(strout, '.mat'),'R','E','C')
%% Plots in the plane (hkl)
%
str_title = {'Young''s modulus E_1'' in GPa'
    'Poisson''s ratio v_{12}'''
    'Shear modulus G_{12}'' in GPa'
    'Long. and Trans. piezoresitive coeff pi_L for p-type in Pa^{-1}'
    'Long. and Trans. piezoresitive coeff pi_L for n-type in Pa^{-1}'};

% Plots elastic elastic constants
f1= figure('Name',strcat('Elastic Constants for: ',strout));
for  i=1:3
subplot(2,2,i)
polarplot(R(:,1),R(:,i+2))
title(str_title(i,:))
end
% Plots piezoresistive coefficients
f2= figure('Name',strcat('Piezoresistive coefficients for: ', strout));
for  i=1:2
   ii=(i-1)*2;
subplot(2,1,i)
polarplot(R(:,1),R(:,ii+6),R(:,1),R(:,ii+7))
title(str_title(3+i,:))
legend('\pi_L'' = \pi_{11}''', '\pi_T''= \pi_{12}''' )
end

%% Functions
function E= Elasticonstant(x, x_prime, angle_hkl_deg)    
%  Compute constants and coefficients
%  Input:     three 1x3 vectors  x(i,:)
%             three 1x3 vectors  x_prime(i,:)
%             1xn vector of angles angle_hkl_deg in degree
%  Output:    1xn vector of young's modulus              E.E(i) in Gpa
%             1xn vector of poisson's ratio              E.v(i)
%             1xn vector of Shear modulus                E.G(i) in Gpa
%             1xn vector of Long. piezoresitive coeff    E.piL(t,i) in Pa^-1 t: 1,2 for p- or n-type
%             1xn vector of Trans. piezoresitive coeff   E.piL(t,i) in Pa^-1 t: 1,2 for p- or n-type
    global C R

    % Compute Eulerian angles in rad
    abc= eulerianAngle(x, x_prime)

    E.angle_hkl_deg= angle_hkl_deg;
    E.angle_hkl_rad= deg2rad(angle_hkl_deg);

    c = E.angle_hkl_rad+abc(3); % correction of angle vector 

    %  compute elastic constants,  long. and trans. piezoresistive coefficients for each c angle
    for p= 1:size(c,2) % 

        %  cosines and sines from Eulerian angles
        ca =  cos(abc(1));
        sa =  sin(abc(1));
        cb =  cos(abc(2));
        sb =  sin(abc(2));
        cc =  cos(c(p));
        sc =  sin(c(p));

        % compute l_i, m_i, n_i
        l=[ca*cb*cc-sa*sc -ca*cb*sc-sa*cc ca*sb]';
        m=[sa*cb*cc+ca*sc -sa*cb*sc+ca*cc sa*sb]';
        n=[-sb*cc sb*sc cb]';
               

        % Compute E_1', v_{12}', G_{12}'
        i= 1;
        j= 2;
        s= 2*((C.s(1)-C.s(2))-C.s(3)/2);
        E.E(p)= 10^(-9)./...
        (C.s(1)-s*(l(i)^2*m(i)^2+l(i)^2*n(i)^2+m(i)^2*n(i)^2));% in GPa
        E.v(p)= -(2*C.s(2)+s*(l(i)^2*l(j)^2+m(i)^2*m(j)^2+n(i)^2*n(j)^2))/...
        (2*C.s(1)-2*s*(l(i)^2*m(i)^2+l(i)^2*n(i)^2+m(i)^2*n(i)^2));
        E.G(p)= 10^(-9)./...
        (C.s(3)+2*s*(l(i)^2*l(j)^2+m(i)^2*m(j)^2+n(i)^2*n(j)^2));% in GPa    

        % Compute pi_L' = pi_{11}', pi_T' = pi_{12}' for p-type in Pa^-1
        i = 1;
        j = 2;
        t = 1;% p-type
        E.piL(t,p)= (C.pi(t,1)-2*(C.pi(t,1)-C.pi(t,2)-C.pi(t,3))*...
        (l(i)^2*m(i)^2+l(i)^2*n(i)^2+m(i)^2*n(i)^2)); % in Pa^-1
        E.piT(t,p)= (C.pi(t,2)+(C.pi(t,1)-C.pi(t,2)-C.pi(t,3))*...
        (l(i)^2*l(j)^2+m(i)^2*m(j)^2+n(i)^2*n(j)^2)); % in Pa^-1

        % Compute pi_L' = pi_{11}', pi_T' = pi_{12}' for n-type in Pa^-1
        i = 1;
        j = 2;
        t = 2;% n-type
        E.piL(t,p)= (C.pi(t,1)-2*(C.pi(t,1)-C.pi(t,2)-C.pi(t,3))*...
        (l(i)^2*m(i)^2+l(i)^2*n(i)^2+m(i)^2*n(i)^2));
        E.piT(t,p)= (C.pi(t,2)+(C.pi(t,1)-C.pi(t,2)-C.pi(t,3))*...
        (l(i)^2*l(j)^2+m(i)^2*m(j)^2+n(i)^2*n(j)^2)); 

    end
end
%%
%  ---
function abc= eulerianAngle(x, x_prime)
%  Compute Eulerian angles $\alpha,\beta, \gamma$ noted a b c between the bases $x_i$ noted x and $x_i'$  noted x_prime
%  Input:     three 1x3 vectors  x(i,:)
%             three 1x3 vectors  x_prime(i,:)
%  Output:    three Eulerian angles abc = $[\alpha,\beta, \gamma]$

    %  Compute Projection of x_3' on the plane (x_1 x_2) and vector N (line node direction)
    Px3_prime= [dot(x_prime(3,:), x(1,:))/norm(x(1,:))^2 dot(x_prime(3,:), x(2,:))/norm(x(2,:))^2 0]
    rotZ_90degree = [0 -1 0;1 0 0;0 0 1];% pi/2 rotation of Px3_prime on x(3,:)
    N = [rotZ_90degree*Px3_prime']'   
    % Assignment of the basis vectors $x_i'$
    abc = [AngleBtwVectors(N, x(2,:)),AngleBtwVectors(x_prime(3,:), x(3,:)),AngleBtwVectors(x_prime(2,:), N)];
end
%%
%  ---
function theta = AngleBtwVectors(u, v)

%  Compute angles theta between both vectors u,v
%  Input:     two 1x3 vectors  u, v
%  Output:    angles theta between both vectors u,v
%  $\theta = acos (\frac{1}{abs(u)abs(v)})$

    theta = acos(dot(u, v)/(norm(u) * norm(v)));

end
