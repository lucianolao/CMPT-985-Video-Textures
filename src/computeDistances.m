function [D] = computeDistances(video, n_frames, half_window)

% compute window
window = computeWindow(half_window);

D = zeros(n_frames, n_frames);
D(:,:) = Inf; % Inf or 0
n_elements = numel(video(1).img);

% compute distances
for i = 1 : n_frames
    im1 = video(i).img;
    for j = (i+1) : n_frames
        im2 = video(j).img;
        % L2 distance
        I = (im1 - im2) .^ 2;
        I = sum(I(:));
        I = I / n_elements;
        I = sqrt(I);
        % Assign it to matrix D
        D(i,j) = I;
        D(j,i) = I;
    end
end

% Apply weights using window
crossCorrelation(D, window)

end

