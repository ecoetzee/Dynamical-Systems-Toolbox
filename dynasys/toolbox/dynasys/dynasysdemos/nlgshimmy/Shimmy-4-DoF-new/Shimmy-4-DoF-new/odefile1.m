% Vector field from the somieski-modelling of shimmy
function varargout = odefile1(t,y,flag,parameters)

switch flag

    case 'events'
        [varargout{1:3}]=events(y,parameters);

    case ''
        [varargout{1}]=f(y,parameters);

end
% The ODE's defining the dynamical system
function dydt = f(y,parameters)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%parameters(1)=h - half contact patch length
h=parameters(1);

%parameters(2)=e - mechanical trail;
e=parameters(2);

%parameters(3)=v - velocity
v=parameters(3);

%parameters(4)=Fz - vertical force;
Fz=parameters(4);

%parameters(5)=k_s_psi - torsinal stiffness of the strut;
k_s_psi=parameters(5);

%parameters(6)=k_s_delta - strut bending stiffness w.r.t x-axis;
k_s_delta=parameters(6);

%parameters(7)=k_s_beta - strut bending stiffness w.r.t y-axis;
k_s_beta=parameters(7);

%parameters(8)=k_t_lambda - tyre lateral/side force coefficient;
k_t_lambda=parameters(8);

%parameters(9)=k_t_alpha - tyre torsional stiffness coefficient;
k_t_alpha=parameters(9);

%parameters(10)=C_t_lambda - tyre lateral/side damping coefficient;
c_t_lambda=parameters(10);

%parameters(11)=C_t_alpha - tyre torsional damping coefficient;
c_t_alpha=parameters(11);

%parameters(12)=C_s_psi - strut torsional damping coefficient;
c_s_psi=parameters(12);

%parameters(13)=C_s_delta - strut damping coefficient w.r.t x-axis;
c_s_delta=parameters(13);

%parameters(14)=C_s_beta - strut damping coefficient w.r.t y-axis;
c_s_beta=parameters(14);

%parameters(15)=Iz - moment of inertia w.r.t the z- axis;
Iz=parameters(15);

%parameters(16)=Ix - moment of inertia w.r.t the x- axis;
Ix=parameters(16);

%parameters(17)=Iy - moment of inertia w.r.t the y- axis;
Iy=parameters(17);

%parameters(18)=L relaxation length
L=parameters(18);

%parameters(19)=cfl - cornering-force limit;
cfl=parameters(19);

%parameters(20)=sal - self-aligning limit;
sal=parameters(20);

%parameters(21)=rake - rake angles;
rake = parameters(21);

%parameters(22)=R - Radius of the deformated tyre;
R = parameters(22);

%height of the landing gear
Hlg=2.5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alpha=atan(y(7)/L); % slip angle
e_eff=e*cos(rake+y(5))+R*tan(rake+y(5))+e*sin(rake+y(5))*tan(rake+y(5));% effective caster length
theta=y(1)*cos(rake+y(5)); % swivel
gamma=y(1)*sin(rake+y(5)); % tilt

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% torsional stiffness force from the swivel
M_K_psi=-k_s_psi*y(1); % moment

% torsional damping from the swivel
M_D_psi=-c_s_psi*y(2); % moment

% cornering force - taken in bilinear form
% if abs(alpha) <= cfl
%     F_K_lambda=-k_t_lambda*y(7); % force
% else
%     F_K_lambda=-k_t_lambda*L*tan(cfl)*sign(y(7)); % force
% end
F_K_lambda=-k_t_lambda*tan(1.05*alpha)/(1.0+(3.2*tan(1.05*alpha))^2);
M_K_lambda_psi=F_K_lambda*e_eff;

% self-aligning moment
t=0.1*cos(1.9*atan(0.5*alpha+atan(3.0*alpha)));
M_K_alpha=F_K_lambda*t;
% if abs(alpha) <= sal
%     M_K_alpha=-k_t_alpha*7.5*sin(alpha*90/7.5)/90; % moment
% else
%     M_K_alpha=0; % moment
% end

% damping force due to the thread-width
F_D_lambda=-c_t_lambda*(v*sin(y(1)*cos(rake+y(5)))+(e_eff-h)*y(2)*cos(rake+y(5))*cos(y(1)*cos(rake+y(5)))...
    -(v/L)*y(7)*cos(y(1)*cos(rake+y(5)))+2.5*cos(y(3))*y(4)); % force
M_D_lambda=F_D_lambda*e_eff; % moment

% structural stiffness force w.r.t x-axis
M_K_delta=-k_s_delta*y(3); % moment

% structural damping force w.r.t x-axis`    
M_D_delta=-c_s_delta*y(4); % moment

% lateral deformation effect on the delta-motion
F_lambda_delta=F_K_lambda*cos(theta); % force
M_lambda_delta=F_lambda_delta*Hlg*cos(rake+y(5)); % moment

% structural stiffness force w.r.t y-axis
M_K_beta=-k_s_beta*y(5); % moment

% structural damping force w.r.t y-axis
M_D_beta=-c_s_beta*y(6); % moment

% lateral deformation effect on the beta-motion
F_lambda_beta=F_K_lambda*sin(theta); % force
M_lambda_beta=F_lambda_beta*Hlg*cos(rake+y(5)); % moment

% M_K_psi
% M_D_psi
% M_K_lambda_psi
% M_K_alpha
% M_D_lambda
% M_K_delta
% M_D_delta
% M_lambda_delta
% Fz*e_eff*sin(theta)
% M_K_beta
% M_D_beta
% M_lambda_beta
% Fz*(e_eff-Hlg*sin(rake+y(5)))
% y
% pause
% Nonlinear Set of Eqns
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dydt = [y(2);...
        1/Iz*(M_K_psi+M_D_psi+M_K_lambda_psi+M_K_alpha+Fz*sin(rake+y(5))*e_eff*sin(theta));...
        y(4);...
        1/Ix*(M_K_delta+M_D_delta+M_lambda_delta+Fz*e_eff*sin(theta));...
        y(6);...
        1/Iy*(M_K_beta+M_D_beta+M_lambda_beta+Fz*(e_eff-Hlg*sin(rake+y(5))));...
        v*sin(y(1)*cos(rake+y(5)))+(e_eff-h)*y(2)*cos(rake+y(5))*cos(y(1)*cos(rake+y(5)))-(v/L)*y(7)*cos(y(1)*cos(rake+y(5)))+2.5*cos(y(3))*y(4)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Events monitored during integration and continuation
function [value,isterminal,direction]=events(y,parameters)

value=[y(2)];
isterminal=[0];
direction=[-1];