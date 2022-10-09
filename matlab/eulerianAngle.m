function abc= eulerianAngle(x, x_prime)
%EULERIANANGLE  Compute Eulerian angles $\alpha,\beta, \gamma$ noted a b c between the bases $x_i$ noted x and $x_i'$  noted x_prime
%  Input:     base x 1x3 vectors  x(i,:)
%             base x 1x3 vectors  x_prime(i,:)
%  Output:    three Eulerian angles abc = $[\alpha,\beta, \gamma]$

    %  Compute Projection of x_3' on the plane (x_1 x_2) and vector N (line node direction)
    Px3_prime= [dot(x_prime(3,:), x(1,:))/norm(x(1,:))^2 dot(x_prime(3,:), x(2,:))/norm(x(2,:))^2 0]
    rotZ_90degree = [0 -1 0;1 0 0;0 0 1];% pi/2 rotation of Px3_prime on x(3,:)
    N = [rotZ_90degree*Px3_prime']'   
    % Assignment of the basis vectors $x_i'$
    abc = [AngleBtwVectors(N, x(2,:)),AngleBtwVectors(x_prime(3,:), x(3,:)),AngleBtwVectors(x_prime(2,:), N)];
end

