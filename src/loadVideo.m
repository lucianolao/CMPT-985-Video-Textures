function [vid, height, width, n_frames] = loadVideo(filepath)

data = VideoReader(filepath);

height = data.Height;
width = data.Width;
n_frames = data.NumFrames;

% Preallocate movie structure
% vid(1:n_frames) = struct('img', zeros(height, width, 3, 'uint8'), 'colormap', []);
vid(1:n_frames) = struct('img', zeros(height, width, 3), 'colormap', []);

% ref = read(data, 1);

for i = 1 : n_frames
    fprintf('Loading %d/%d\n', i, n_frames);
    vid(i).img = read(data, i);
    %vid(i).img = im2double(read(data, i));
    
    %I = read(data, i);
    %vid(i).img = imhistmatch(I, ref);
end


end

