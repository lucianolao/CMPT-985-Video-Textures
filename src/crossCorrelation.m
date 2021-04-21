function [J] = crossCorrelation(I, window, n_skip)

% handling frames to skip
half_window = floor(length(window)/2);
n_skip = floor(n_skip/2);
n_skip = n_skip - half_window;
if n_skip > 0
    window = padarray(window, n_skip, 0);
else
    n_skip = 0;
end

% diagonal matrix with the weights
D = diag(window);

% flip kernel (again) so convn becomes a cross-correlation
kernel = rot90(D,2);
%kernel = flip(flip(D, 1), 2);

J = convn(I, kernel, 'valid'); % full, same, valid

J(isnan(J)) = Inf;

J = padarray(J, [half_window+n_skip half_window+n_skip], Inf);

end

