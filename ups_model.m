function [ ups ] = ups_model( R_L ) 

% UPS parameters
Kpwm = 1;
Rlf  = 0.2;
Lf   = 0.001;
Cf   = 0.00002;

% UPS model
A = [-(Rlf/Lf) -1/Lf;
      1/Cf     -1/(R_L*Cf)];
B = [Kpwm/Lf; 0];
C = [0 1];
D = 0;
E = [0;  -1/Cf];
ups = struct('A',A, 'B',B, 'C',C, 'D',D, 'E',E, 'Rlf',Rlf, 'Lf',Lf, 'Cf',Cf);