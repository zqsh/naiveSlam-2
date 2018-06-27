%wrapper out ::todo
function F = fundamentalEightPoint_normalized(p1, p2)
% Input: point correspondences
%  - p1(3,N): homogeneous coordinates of 2-D points in image 1
%  - p2(3,N): homogeneous coordinates of 2-D points in image 2
%
% Output:
%  - F(3,3) : fundamental matrix
%

[x1_nh,T1] = normalise2dpts(p1);
[x2_nh,T2] = normalise2dpts(p2);

if(isnan(sum(sum(x1_nh))) || isnan(sum(sum(x2_nh))))
    test = 0;
end

% Linear solution
F = fundamentalEightPoint(x1_nh,x2_nh);

% Undo the normalization
F = (T2.') * F * T1;

end
