function render(list_frames, video, filepath, half_window, use_cross_fading, is_final_rendering)

window_size = 2*half_window + 1;
weight = 1/window_size;

n_new_frames = length(list_frames);

file = VideoWriter(filepath, 'MPEG-4');

open(file);

i = 1;
while i <= n_new_frames
    y = list_frames(i);
    if i+half_window > n_new_frames
        if is_final_rendering
            fprintf('Saving %d/%d\n', i, n_new_frames);
        end
        writeVideo(file, video(y).img);
        i = i+1;
    elseif list_frames(i+half_window) == y+half_window
        if is_final_rendering
            fprintf('Saving %d/%d\n', i, n_new_frames);
        end
        writeVideo(file, video(y).img);
        i = i+1;
    elseif use_cross_fading
        % Cross-fading
        fprintf('Cross-fading\n');
        x = list_frames(i+half_window);
        x = x - half_window;
        lambda = 0;
        for j = 1:window_size
            if is_final_rendering
                fprintf('Saving %d/%d\n', i, n_new_frames);
            end
            lambda = lambda + weight;
            im1 = video(y).img;
            im2 = video(x).img;
            %im1 = im1 ./ 2;
            %im2 = im2 ./ 2;
            faded = (1-lambda)*im1 + (lambda)*im2;
            writeVideo(file, faded);
            i = i+1;
            y = y+1;
            x = x+1;
        end
    else
        if is_final_rendering
            fprintf('Saving %d/%d\n', i, n_new_frames);
        end
        writeVideo(file, video(y).img);
        i = i+1;
    end
    
end

close(file);


end

