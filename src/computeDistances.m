function [D] = computeDistances(video, n_frames, half_window, n_skip)

% compute window
window = computeWindow(half_window);

D = zeros(n_frames, n_frames);
D(:,:) = NaN; % Inf or 0
% n_elements = numel(video(1).img);
% n_elements = n_elements/3;

% compute distances
for i = 1 : n_frames
    im1 = video(i).img;
    im1 = rgb2gray(im1);
    im1 = imgaussfilt(im1,2);
    for j = (i+1) : n_frames
        im2 = video(j).img;
        im2 = rgb2gray(im2);
        im2 = imgaussfilt(im2,2);
        % L2 distance
        I = (im1 - im2) .^ 2;
        %I = sum(I(:));
        %I = I / n_elements;
        I = mean(I(:));
        I = sqrt(I);
        % Assign it to matrix D
        %D(i,j) = I; % jumping forward
        D(j,i) = I; % jumping backwards
    end
end

% Apply weights using window
D = crossCorrelation(D, window, n_skip);

end

