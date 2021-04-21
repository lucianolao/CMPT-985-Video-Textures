function [list_frames] = synthesis(list_frames, n_frames, y, x, min_seq)
% Sequencing the video texture

last_frame = list_frames(end);

remaining_frames = last_frame+1 : y-1;
list_frames = [list_frames remaining_frames];

list_frames = [list_frames x];
for i = 1:min_seq-1
    if x+i <= n_frames
        list_frames = [list_frames x+i];
    end
end


end

