% this function is created by Ahmed ElTahan
%It's intended to substitute the values of the inputs to a polynomial
%function and getting the output of these inputs. The polynomial degree
%must be specified.


function [ Output ] = fitval( Coefficients, Inputs, degree )

syms y(u)
y(u) = Coefficients(1);
if(length(Coefficients)>1)
    for m =1 :degree
 
        y(u) = y(u) +Coefficients(m+1)*u^(m);

            for m = 1: length(Inputs)
                Output(m) = y(Inputs(m));
            end

        Output = double(Output);
    end
    
end

if(length(Coefficients)==1)
    Output = Coefficients(1)*ones(length(Inputs), 1);
end

end



