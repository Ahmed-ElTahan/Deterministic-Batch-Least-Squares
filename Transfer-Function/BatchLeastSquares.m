% This function is made by Ahmed ElTahan

%{
        This function is intended to estimate the parameters of a dynamic
        system of unknown parameters using the Batch Least Squares Method (BLS).
        After an experiment, we get the inputs, the outputs of the system. 
        The experiment is operated with sample time Ts seconds. 
        The system here is transfer function in the form of:

                                            y         z^(-d) Bsys
                                Gp = ------ = ----------------------
                                            u               Asys
                                    
                                 Asys * y = z^(-d) Bsys * u + e

    where:
    -- y : output of the system.
    -- u : control action (input to the system).
    -- e : white guassian noise (noise with zero mean).
    -- Asys = 1 + a_1 z^-1 + a_2 z^-1 + ... + a_na z^(-na).
    -- Bsys = b_0 + b_1 z^-1 + b_2 z^-1 + ... + b_nb z^(-nb).
    -- d : delay in the system.

    Function inputs
    u : input to the system in column vector form
    y : input of the system in column vector form
    na : order of the denominator polynomail
    nb : order of the numerator polynomail
    d : number represents the delay between the input and the output
    
    Function Output
    Theta : final estimated parameters.
    Gz_estm : pulse (discrete) transfer function of the estimated parameters
    1 figure to validate the estimated parameters on the given output

    An example is added to illustrate how to use the funcrtion
%}


function [ theta, Gz_estm ] = BatchLeastSquares( u, y, na, nb, d, Ts )



nu = na + nb + 1; % number of unkowns
N = length(y); % length of the vectors
n = max(na+1, nb+d+1); % used to avoid zeros at the begining and added 1 to avoid zero index in matlab
ne = N - n + 1; % number of equations that will used in estimation

 %% Regression Matrix "Phi" preparation 
    % 2 inner for loops to fill the Phi matrix, "j" deals with the rows and ''i'' deals with the columns.
    % full the Phi matrix starting from j = 1 and that means start from
    % y(1) = -a1*y(0) - a2*y(-1) - ... + b0 u(1-d) + b1 u(1-d-1) + ...
    % zero and negtive indeces will be set to zero by checking (i-j) value
    
    for j = 1 : N
        for i = 1 : na % this for loop used to fill parts in the same line that pertains to the output "denomenator"
            if ((j-i)<=0)
                Phi(j, i) = 0;
            else
                Phi(j, i) = -y((j-i));
            end
        end
    
        
        for i = na+1 : nu % this for loop used to fill parts in the same line that pertains to the input "numerator" starts from the last postion column of "na +1 
            if ((j-(i-na)-d)<=0) % add na as we left the output going to the input and we start index after "na"
                Phi(j, i) = 0;
            else
            Phi(j, i) = u((j-d-i + (na+1)));
            end
        end
    end    

 %% Parameters and transfer function preparation   
 theta = inv(Phi'*Phi)*Phi'*y; % Estimated parameters
 z = tf('z');
 A = z^(d+nb);
 B = 0;
for i = 1:na
    a(i) = theta(i);
    A = A + a(i)*z^(d-na+nb+na-i);
end
for i = na+1:nu
    b(i-na) = theta(i);
    B = B + b(i-na)*z^(nb - (i-(na+1)));
end

Gz_estm = B/A;
[num, den] = tfdata(Gz_estm);
num = cell2mat(num);
den = cell2mat(den);
Gz_estm = tf(num, den, Ts);

%% Validation
final_time = (N-1)*Ts;
t = 0:Ts:final_time;

%original system
h = figure;
hold all
plot(t, y, 'LineWidth', 2)
grid on 

% estimated system
y_estm = Phi*theta; % well attention
plot(t, y_estm, 'LineWidth', 2);
legend(['Ordinary System'], ['Estimated System ',num2str(na), ' Order']);
xlabel('Time (sec.)');
ylabel('Output');
title('Output Versus Time')
print(h,'-dpng','-r500','Output')

% Input plot over time
h = figure;
plot(t, u, 'LineWidth', 2);
xlabel('Time (sec.)');
ylabel('Input');
title('Input Versus Time')
grid on 
print(h,'-dpng','-r500','Input')
end

