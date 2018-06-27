% Input:
%   - x(3,1) : vector
%
% Output:
%   - M(3,3) : antisymmetric matrix
%

function M = cross2Matrix(x)
M = [0    -x(3)  x(2);
     x(3)   0   -x(1);
    -x(2)  x(1)   0  ];

