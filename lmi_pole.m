function [ K ] = lmi_pole( agm, sig )

% extract augmented model
A_a = agm.A_a;
B_a = agm.B_a;
C_a = agm.C_a; 

% regional pole placement LMI
[n,p]  = size(B_a);
Q      = sdpvar(n,n, 'symmetric');   % n x n symmetric variable
W      = sdpvar(p,n);                % n x n variable

L1     = 2*sig;
M1     = 1;
L2     = -50000*eye(2);
M2     = [0 1; 0 0];
Sigma  = A_a*Q +B_a*W;


LMIS = Q>0;

LMIS = [ LMIS, ...
         Sigma+Sigma'<0 ];

LMIS = [ LMIS, ...
         (kron(L1,Q)+kron(M1,Sigma)+kron(M1.',Sigma'))<0 ];
           
LMIS = [ LMIS, ...
         (kron(L2,Q)+kron(M2,Sigma)+kron(M2.',Sigma'))<0 ];

% settings and solve
opt                   = sdpsettings('solver','lmilab','verbose',2);
opt.lmilab.maxiter    = 1000;
opt.lmilab.feasradius = 1e20;
solution              = solvesdp(LMIS,[],opt);

K = double(W)/double(Q);