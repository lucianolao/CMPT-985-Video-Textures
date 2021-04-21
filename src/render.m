function render(list_frames, video, filepath, half_window)

n_new_frames = length(list_frames);

file = VideoWriter(filepath, 'MPEG-4');

open(file);

for i = 1:n_new_frames
    fprintf('Saving %d/%d\n', i, n_new_frames);
    idx = list_frames(i);
    writeVideo(file, video(idx).img);
end

close(file);


end

