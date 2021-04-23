function [video, height, width, n_frames] = loadVideo(filepath)

data = VideoReader(filepath);

height = data.Height;
width = data.Width;
n_frames = data.NumFrames;

% Preallocate movie structure
% vid(1:n_frames) = struct('img', zeros(height, width, 3, 'uint8'), 'colormap', []);
video(1:n_frames) = struct('img', zeros(height, width, 3), 'colormap', [], 'gray_blur', zeros(height, width));

% ref = read(data, 1);

for i = 1 : n_frames
    fprintf('Loading %d/%d\n', i, n_frames);
    I = read(data, i);
    
    video(i).img = I;
    
    %video(i).img = im2double(I);
    
%     video(i).img = imhistmatch(I, ref);
    
    I = rgb2gray(I);
    I = imgaussfilt(I,2);
    video(i).gray_blur = I;
end


end

