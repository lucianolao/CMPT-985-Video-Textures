function saveVideo(video, n_frames, filepath)


file = VideoWriter(filepath, 'MPEG-4');

open(file);

for i = 1:n_frames
    fprintf('Saving %d/%d\n', i, n_frames);
    writeVideo(file, video(i).img);
end

close(file);

end

