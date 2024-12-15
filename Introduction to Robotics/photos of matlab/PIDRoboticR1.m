clc;
clear;

% Parameters of the robot
link_lengths = [0.35, 0.40, 0.15]; % Lengths of the links (m)
link_masses = [1.5, 1.2, 0.8]; % Masses of the links (kg)

% Initial and desired joint positions
q_init = [0, 0, 0]; % Initial positions [rad]
q_desired = [pi/4, pi/6, pi/3]; % Desired positions [rad]

% PID gains (adjust these for tuning)
Kp = [50, 50, 50]; % Proportional gains
Ki = [5, 5, 5]; % Integral gains
Kd = [10, 10, 10]; % Derivative gains

% Simulation parameters
dt = 0.01; % Time step (s)
t_end = 5; % Simulation duration (s)
time = 0:dt:t_end; % Time vector

% Initialize variables
q = q_init; % Current joint positions
q_dot = [0, 0, 0]; % Current joint velocities
q_int = [0, 0, 0]; % Integral of error
torques = zeros(length(time), 3); % Store torques
positions = zeros(length(time), 3); % Store positions

% Simulation loop
for t = 1:length(time)
    % Compute error
    error = q_desired - q; % Position error
    q_int = q_int + error * dt; % Integrate error
    q_dot_error = -q_dot; % Velocity error (simplified model)

    % Compute torques using PID
    tau = Kp .* error + Ki .* q_int + Kd .* q_dot_error;

    % Update joint accelerations (simplified dynamics: τ ≈ q_ddot)
    q_ddot = tau; % Assuming unit inertia for simplicity

    % Update velocities and positions
    q_dot = q_dot + q_ddot * dt; % Update velocity
    q = q + q_dot * dt; % Update position

    % Store results
    torques(t, :) = tau;
    positions(t, :) = q;
end

% Plot results
figure;

% Joint positions
subplot(2, 1, 1);
plot(time, positions(:, 1), 'r', time, positions(:, 2), 'g', time, positions(:, 3), 'b');
hold on;
yline(q_desired(1), '--r');
yline(q_desired(2), '--g');
yline(q_desired(3), '--b');
title('Joint Positions');
xlabel('Time (s)');
ylabel('Position (rad)');
legend('Joint 1', 'Joint 2', 'Joint 3', 'Desired Joint 1', 'Desired Joint 2', 'Desired Joint 3');
grid on;

% Joint torques
subplot(2, 1, 2);
plot(time, torques(:, 1), 'r', time, torques(:, 2), 'g', time, torques(:, 3), 'b');
title('Joint Torques');
xlabel('Time (s)');
ylabel('Torque (Nm)');
legend('Joint 1', 'Joint 2', 'Joint 3');
grid on;
