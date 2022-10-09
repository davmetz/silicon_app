function theta = AngleBtwVectors(u, v)
%ANGLEBTWVECTORS  Compute angles theta between both vectors u,v
%  Input:     two 1x3 vectors  u, v
%  Output:    angles theta between both vectors u,v
%  $\theta = acos (\frac{1}{abs(u)abs(v)})$
    theta = acos(dot(u, v)/(norm(u) * norm(v)));
end