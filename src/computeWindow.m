function [window] = computeWindow(half_window)

window_size = half_window*2 + 1;
window = zeros(window_size,1);

% first and last weights
window(1) = 1;
window(window_size) = 1;

% compute weights in between
for i = 2 : (half_window+1)
    previous = window(i-1);
    window(i) = previous*2;
    window(window_size-i+1) = previous*2;
end

% normalize weights tom sum to 1
window = window ./ sum(window);

end
