% Parameters
L1 = 0.35; % Length of Link 1 (m)
L2 = 0.40; % Length of Link 2 (m)
L3 = 0.15; % Length of Link 3 (m)
L4 = 0.10; % Length of Link 4 (m)

m1 = 1.5;  % Mass of Link 1 (kg)
m2 = 1.2;  % Mass of Link 2 (kg)
m3 = 0.8;  % Mass of Link 3 (kg)
m4 = 0.5;  % Mass of Link 4 (kg)
m_load = 0.5; % Mass of Load (kg)

g = 9.81;  % Gravitational force (m/s^2)

% Moments of inertia (thin cylindrical links)
I1 = (1/3) * m1 * L1^2;
I2 = (1/3) * m2 * L2^2;
I3 = (1/3) * m3 * L3^2;
I4 = (1/3) * m4 * L4^2;

%% Inertia Matrix M(q)
M = [
    I1 + I2 + I3 + I4, 0, 0, 0;
    0, I2 + I3 + I4, 0, 0;
    0, 0, I3 + I4, 0;
    0, 0, 0, I4
];

disp('Inertia Matrix M(q):');
disp(M);

%% Coriolis Matrix C(q, q_dot)
syms q1_dot q2_dot q3_dot q4_dot real
C = [
    0, -q2_dot, -q3_dot, -q4_dot;
    q1_dot, 0, -q3_dot, -q4_dot;
    q1_dot, q2_dot, 0, -q4_dot;
    q1_dot, q2_dot, q3_dot, 0
];
disp('Coriolis Matrix C(q, q_dot):');
disp(C);

%% Gravitational Terms G(q)
h1 = L1 / 2;  % Center of mass of Link 1
h2 = L2 / 2;  % Center of mass of Link 2
h3 = L3 / 2;  % Center of mass of Link 3
h4 = L4 / 2;  % Center of mass of Link 4

G1 = m1 * g * h1;  % Gravitational torque for Link 1
G2 = m2 * g * h2;  % Gravitational torque for Link 2
G3 = m3 * g * h3 + m_load * g * L3;  % Link 3 + Load
G4 = m4 * g * h4 + m_load * g * L4;  % Link 4 + Load

G = [
    G1;
    G2;
    G3;
    G4
];

disp('Gravitational Terms G(q):');
disp(G);
