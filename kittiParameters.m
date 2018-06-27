global harris_patch_size;
global harris_kappa;
global num_keypoints;
global nonmaximum_supression_radius;
global descriptor_radius;
global match_lambda;
global triangulationTolerance;
global p3pIterations;
global p3pTolerance;
global p3pSample;
global triangulationIterations;
global initializationIterations;
global triangulationSample;
global dataBaseSize;
global max_dif;
global min_dif;
global triangulationRansac;
global stereoParams;
global cameraPara1;
global cameraPara2;
global Project1;
global Project2;
global K1;
% Size of Harris search patch
harris_patch_size = 11;
% Magic number in range (0.04 to 0.15)
harris_kappa = 0.08;
% Number of harris corners to find
num_keypoints = 2000;
% Size of patch to suppress around keypoint
nonmaximum_supression_radius = 5;
% Size of harris descriptor
descriptor_radius = 11;
% Matching parameter for harris corners,
% a higher number means more matches of lower quality
match_lambda = 3;
% Pixel distance from epipolar line that is acceptable for
% a newly triangulated landmark
triangulationTolerance = 1;
% Number of iterations to perform RANSAC for p3p pose estimation
p3pIterations = 2000;
% Pixel margin for p3p RANSAC
p3pTolerance = 3;
% Number of sample points for p3p RANSAC
p3pSample = 3;
% Number of iterations to perform RANSAC for triangulating new points
triangulationIterations = 1000;
% Number of iterations to perform RANSAC for initialization
initializationIterations = 2000;
% Number of sample points for triangulation
triangulationSample = 20;
% How many past frames to save for triangulation
dataBaseSize = 3;
% Boundary box around camera where newly triangulated points
% are considered too close and are rejected
max_dif = [ 0.5; 0.5; 0.5];
min_dif = [-0.5; -0.5; -0.5];
% Whether or not to use ransac for triangulating new landmarks
triangulationRansac = true;

A=[[7.215377e+02 0.000000e+00 6.095593e+02 0.000000e+00 0.000000e+00 7.215377e+02 1.728540e+02 0.000000e+00 0.000000e+00 0.000000e+00 1.000000e+00 0.000000e+00];
    [7.215377e+02 0.000000e+00 6.095593e+02 -3.875744e+02 0.000000e+00 7.215377e+02 1.728540e+02 0.000000e+00 0.000000e+00 0.000000e+00 1.000000e+00 0.000000e+00]];
Project1 = vertcat(A(1,1:4), A(1,5:8), A(1,9:12));
Project2 = vertcat(A(2,1:4), A(2,5:8), A(2,9:12));

% A = [[9.842439e+02 0.000000e+00 6.900000e+02 0.000000e+00 9.808141e+02 2.331966e+02 0.000000e+00 0.000000e+00 1.000000e+00]; ...
%      [9.895267e+02 0.000000e+00 7.020000e+02 0.000000e+00 9.878386e+02 2.455590e+02 0.000000e+00 0.000000e+00 1.000000e+00]];
% K1 = vertcat(A(1,1:3), A(1,4:6), A(1,7:9));
% K2 = vertcat(A(2,1:3), A(2,4:6), A(2,7:9));
K1 = Project1(1:3,1:3);
K2 = Project2(1:3,1:3);
%cameraPara1 = cameraParameters('IntrinsicMatrix',K1','RadialDistortion',[-3.728755e-01 2.037299e-01  -7.233722e-02] ,'TangentialDistortion',[2.219027e-03 1.383707e-03]);
%cameraPara2 = cameraParameters('IntrinsicMatrix',K2','RadialDistortion',[-3.644661e-01 1.790019e-01  -5.314062e-02] ,'TangentialDistortion',[1.148107e-03 -6.298563e-04]);
cameraPara1 = cameraParameters('IntrinsicMatrix',K1');
cameraPara2 = cameraParameters('IntrinsicMatrix',K2');

A = [9.993513e-01 1.860866e-02 -3.083487e-02 -1.887662e-02 9.997863e-01 -8.421873e-03 3.067156e-02 8.998467e-03 9.994890e-01];
R01 = vertcat(A(1:3), A(4:6), A(7:9));
T01 = [-5.370000e-01 4.822061e-03 -1.252488e-02]-[2.573699e-16 -1.059758e-16 1.614870e-16];
stereoParams = stereoParameters(cameraPara1,cameraPara2,R01,T01);



