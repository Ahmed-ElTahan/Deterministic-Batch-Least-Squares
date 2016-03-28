clc; clear all; close all;


%% Gathering the input and the output
%Input
u = [1 2 3 4 5 6 7]';
%assume the model coeff that we want to find them but only here we assumed
%that in order to get inputs and outputs
b_0 = 1; 
b_1 = 2;
b_2 = 3;

y = @(u) b_0 + b_1*u + b_2*u.^2;

%Output
Y =  y(u);



%% Plot the original polynomial
figure(1)
plot(u, Y, 'LineWidth', 2);
grid on
legend('Original Polynomial')
title('y = 1+2u+3u^2')
xlabel('Input')
ylabel('output')

%% function usage
pols = [0, 1, 2, 3];

for m =1: length(pols)
[theta, V, sample_var, COV] = fitpoly(Y, u, pols(m)); % [Coefficients, least_square_loss, sample_variance, Cov_matrix] = fitpoly(OUTPUT, INPUT, degree);
output = fitval(theta, u, pols(m)); %OUTPUT = fitval(Coefficients, INPUT, degree)

V
sample_var
COV

figure(2)
hold all
plot(u, output, 'LineWidth', 2)
grid on

end

% plot the solutions
figure(2)
legend('fit deg 0,  loss function = 9842', 'fit deg 1,  loss function = 378', 'fit deg 2,  loss function = 5.7663e-23', 'fit deg 3, loss function = 4.3064e-18')
title('fitting the polynial y = 1+2u+3u^2  using various degrees')
xlabel('Input')
ylabel('output')