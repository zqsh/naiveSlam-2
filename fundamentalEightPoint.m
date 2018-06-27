% fundamentalEightPoint  The 8-point algorithm for the estimation of the fundamental matrix F
% Input: point correspondences
%  - p1(3,N): homogeneous coordinates of 2-D points in image 1
%  - p2(3,N): homogeneous coordinates of 2-D points in image 2
%
% Output:
%  - F(3,3) : fundamental matrix


function F = fundamentalEightPoint(p1,p2)

[dim,NumPoints] = size(p1);
[dim2,NumPoints2] = size(p2);

% Sanity checks
assert(dim==dim2 && NumPoints==NumPoints2,'Size mismatch of input points');
assert(dim==3,'Input arguments are not 2D points');
assert(NumPoints>=8,'Insufficient number of points to compute fundamental matrix (need >=8)');

%svd
A = zeros(NumPoints,9);
for i=1:NumPoints
    A(i,:) = kron(p1(:,i),p2(:,i)).';
end
[~,~,V] = svd(A,0);
F = reshape(V(:,9),3,3);

[u,s,v]=svd(F);
s(3,3)=0;
F=u*s*v';
