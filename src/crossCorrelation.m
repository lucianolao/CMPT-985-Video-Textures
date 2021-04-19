function [J] = crossCorrelation(I, window)

% diagonal matrix with the weights
D = diag(window);

% flip kernel (again) so convn becomes a cross-correlation
kernel = rot90(D,2);
%kernel = flip(flip(D, 1), 2);

J = convn(I, kernel, 'same'); % full, same, valid, 

end

