% function created by Ahmed ElTahan
% it's intended to find the coefficients of a polynomial by fiting the
% given output and the input to a polyonmial of a specified degree
%using the concept of the "Least Squares" after that it returns the
%polynomial coefficients orderd like this : a0 + a1*u +a2*u^2+...+an * u^n
%It also returns the least square loss value and when this value is minimum
%this leads to the closest fitting and right coefficients. An example is
%attacted with the function to demonstrate the concept. The example suppose
%that we have a polynomial that already we know it such as
%{y = 1 + 2*u+3*u} and we want have assumed the input to be
% u = [1 2 3 4 5 6 7]' and once we have the inputs and the ouputs we move
% them to the function and choose the degree of the fitting polynomail from 0 to 3 and
% then get the coefficients and draw the fitted data with the correct
% ouput. Also it calculates the estimated variance and the Covariance
% matrix for the estimated data
function [ Coefficients, V, sample_var, COV ] = fitpoly( Output, Input, degree )

Y = Output;
u = Input;
PHI = [ones(length(u),1)];

    for m = 1:degree
        PHI(:, m+1) = u.^(m);
    end

theta = inv(PHI'*PHI)*PHI'*Y; % this is the eqution which finds the coefficients and give the minimum loss function value
Coefficients = theta;
V = 0.5 * (Y - PHI*theta)'*(Y - PHI*theta); % loss function value

% estimated variance (as the number of observations increase and the regressors don't decrease faster than 1/sqrt(t) ---> the variance decreases and more reliable data)
sample_var = 2*V/(length(Input)-length(Coefficients));
% covariance matrix for the estimated parameters
COV = sample_var * inv(PHI' * PHI);

end

