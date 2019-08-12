function g = ur5FwdKin(joints)
% input: joints is 6*1 vector where joints (i) correspond to joint i in
% gazebo setting.
% output: g is 4*4 transformation matrix relative to base_link

% Define the lengths of the UR5 Robot in meter
L0 = 0.0892;
L1 = 0.425;
L2 = 0.392;
L3 = 0.1093;
L4 = 0.09475;
L5 = 0.0825;

offset=[pi/2;pi/2;0;pi/2;0;0];
joints=joints+offset;


% Define joint angles from input
theta1 = joints(1);
theta2 = joints(2);
theta3 = joints(3);
theta4 = joints(4);
theta5 = joints(5);
theta6 = joints(6);

% Define w's for the twist
w1 = [0 0 1]';
w2 = [1 0 0]';
w3 = [1 0 0]';
w4 = [1 0 0]';
w5 = [0 0 1]';
w6 = [1 0 0]';

w1_hat = [0 -1 0; 1 0 0; 0 0 0];
%w5_hat = w1_hat;
w2_hat = [0 0 0; 0 0 -1; 0 1 0];
%w2_hat = w1_hat;
w3_hat = w2_hat;
w4_hat = w2_hat;
w5_hat = w1_hat;
w6_hat = w1_hat;

% Define q vectors for each twist
q1 = [0 0 0]';
q2 = [0 0 L0]';
q3 = [0 0 L0+L1]';
q4 = [0 0 L0+L1+L2]';
q5 = [L3 0 0]';
q6 = [0 0 L0+L1+L2+L4]';

% Define the twist skew matrices
twist1 = [w1_hat cross(-w1,q1); [0 0 0] 0];
twist2 = [w2_hat cross(-w2,q2); [0 0 0] 0];
twist3 = [w3_hat cross(-w3,q3); [0 0 0] 0];
twist4 = [w4_hat cross(-w4,q4); [0 0 0] 0];
twist5 = [w5_hat cross(-w5,q5); [0 0 0] 0];
twist6 = [w6_hat cross(-w6,q6); [0 0 0] 0];

% Define exp(twist*theta)
screw1 = eye(4) + theta1*twist1 + (1 - cos(theta1))*twist1^2 + (theta1 - sin(theta1))*twist1^3;
screw2 = eye(4) + theta2*twist2 + (1 - cos(theta2))*twist2^2 + (theta2 - sin(theta2))*twist2^3;
screw3 = eye(4) + theta3*twist3 + (1 - cos(theta3))*twist3^2 + (theta3 - sin(theta3))*twist3^3;
screw4 = eye(4) + theta4*twist4 + (1 - cos(theta4))*twist4^2 + (theta4 - sin(theta4))*twist4^3;
screw5 = eye(4) + theta5*twist5 + (1 - cos(theta5))*twist5^2 + (theta5 - sin(theta5))*twist5^3;
screw6 = eye(4) + theta6*twist6 + (1 - cos(theta6))*twist6^2 + (theta6 - sin(theta6))*twist6^3;

% Define gst(0)
gst_0 = [0 0 1 L5+L3; -1 0 0 0; 0 -1 0 L1+L2+L4+L0; 0 0 0 1];

% Generate gst given the screws and gst(0)
g = screw1*screw2*screw3*screw4*screw5*screw6*gst_0;



end
