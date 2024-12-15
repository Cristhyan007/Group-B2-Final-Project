clc;
clear;

% Specifications of the robot (calculated torques and powers)
joint_numbers = [1, 2, 3];
required_torque = [0.96, 1.01, 0.09]; % Required torque for each joint (Nm)
required_power = [1.70, 1.78, 0.17]; % Required power for each joint (W)

% Motor specifications (recommended motors)
motor_torque = [1.6, 1.8, 0.18]; % Maximum torque of selected motors (Nm)
motor_power = [6, 8, 1]; % Maximum power of selected motors (W)

% Create a table for display
motor_table = table(joint_numbers', required_torque', motor_torque', ...
    required_power', motor_power', ...
    'VariableNames', {'Joint', 'Required_Torque_Nm', 'Motor_Torque_Nm', ...
                      'Required_Power_W', 'Motor_Power_W'});

disp('Motor Specifications and Comparison:');
disp(motor_table);

% Plot torque comparison
figure;
subplot(2, 1, 1);
bar(joint_numbers, [required_torque; motor_torque]', 'grouped');
title('Torque Comparison per Joint');
xlabel('Joint');
ylabel('Torque (Nm)');
legend('Required Torque', 'Motor Torque', 'Location', 'NorthWest');
grid on;

% Plot power comparison
subplot(2, 1, 2);
bar(joint_numbers, [required_power; motor_power]', 'grouped');
title('Power Comparison per Joint');
xlabel('Joint');
ylabel('Power (W)');
legend('Required Power', 'Motor Power', 'Location', 'NorthWest');
grid on;
