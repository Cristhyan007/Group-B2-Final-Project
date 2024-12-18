clc;
clear;

% Define link lengths
link1 = 0;   %no
link2 = 35;  %si
link3 = 40;  %si
link4 = 0;   %no
link5 = 0;   %si
link6 = 0;  %no
link7 = 5;  %si

% Define robot links using standard DH parameters: [θ, d, a, α, joint type]
L(1) = Link([0, 0, link1, -pi/2, 0]);
L(2) = Link([0, 0, link2, 0, 0]);      
L(3) = Link([0, 0, link3, 0, 0]);
L(4) = Link([0, 0, link4, -pi/2, 0]);      
L(5) = Link([0, 0, link5, 0, 1]);       % prismatic
L(6) = Link([0, 0, link6, 0, 0]);
L(7) = Link([0, 0, link7, 0, 0]);

% Define the robot model
robot = SerialLink(L, 'name', 'Manipulator');

% Define base rotation angles
thetaX = pi/2;  % base rotation about X-axis
thetaY = 0; 
thetaZ = -pi/2;  % base rotation about Z-axis

% Define the combined transformation (rotate about Z then X)
Rx = trotx(thetaX); % Rotation about X-axis
Ry = troty(thetaY);
Rz = trotz(thetaZ); % Rotation about Z-axis
T_base = Rz * Rx * Ry;  % Combined transformation matrix

% Apply the base transformation to the robot
robot.base = T_base;

% Workspace boundaries [x_min, x_max, y_min, y_max, z_min, z_max]
workspace = [-100, 100, -80, 100, -60, 80];
plot_options = {'workspace', workspace, 'view', [30, 30]};

% Initial home position
q_initial = [0, -pi/2, pi/2, -pi/2, 0, 0, -pi/2]; % [Joint 1, Joint 2, Prismatic Joint, Joint 4]

% Define motion sequences
motions = [
    0, -pi/2, pi/2,-pi/2, 0, 0, -pi/2;       
    0, -pi/2, 0, -pi/2, 0, 0, 0;
    0, -pi/2, 0, -pi/2, 12, 0, 0;
    0, -pi/2, 0, -pi/2, 0, 0, 0;
    0, -pi/2, 0, -pi/2, 0, 0, pi/2;
    0, -pi/2, pi/2, -pi/2, 0, 0, pi/2;
    -pi/2, -pi/2, pi/2, -pi/2, 0, 0, pi/2;
    -pi/2, -pi/2, pi/2, -pi/2, 12, 0, pi/2;
    -pi/2, -pi/2, pi/2, -pi/2, 0, 0, pi/2;
    0, -pi/2, pi/2, -pi/2, 0, 0, 0;
];

% Interpolation Parameters
num_steps = 9; % Number of intermediate steps between motions
motions_interpolated = []; % To store interpolated motions

% Generate interpolated joint values considering velocity
for i = 1:size(motions, 1)-1
    q_start = motions(i, :);       % Start configuration
    q_end = motions(i+1, :);       % End configuration
    
    
    % Interpolate each joint position over time
    q_interp = zeros(num_steps, size(motions, 2)); % Preallocate for efficiency
    for j = 1:size(motions, 2)
        q_interp(:, j) = linspace(q_start(j), q_end(j), num_steps); % Interpolate each joint
    end
    
    motions_interpolated = [motions_interpolated; q_interp]; % Append interpolated motions
end

% Visualize the interpolated motion
figure;
robot.plot(q_initial, 'workspace', workspace, 'linkcolor', [1, 0, 0], ...
           'basecolor', [0, 0, 0], 'jointcolor', [0.75, 0.75, 0.75]);
title('Robot manipulator simulation');
hold on;

for i = 1:size(motions_interpolated, 1)
    q = motions_interpolated(i, :); % Get interpolated joint configuration
    robot.plot(q, plot_options{:}); % Visualize the configuration
    pause(0.01); % Adjust for smoother animation
end