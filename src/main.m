clc
clear variables
close all

% %%%%%%%%%% PARAMETERS %%%%%%%%%%
 
filename = "hamster";
half_window = 4;
n_skip = 7; % skip n frames ahead and before (even number for this implementation)
min_seq = 7; % minimum number of frames in a sequence (without cuts)
threshold = 2;
n_jump_options = 1; % find cuts with n number of options to jump (n = 1 for best results)
use_cross_fading = true;
should_finish_at_last_frame = false;
user_input = true;
max_cuts = 5;

% filename = "clock";
% half_window = 4;
% n_skip = 10;
% min_seq = 15;
% threshold = 1.2;
% n_jump_options = 1;
% use_cross_fading = true;
% should_finish_at_last_frame = false;
% user_input = false;
% max_cuts = 10;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

input_folder = "../input/";
output_folder = "../output/";
jumps_folder = "../jumps/";

% Load video
[video, h, w, n_frames] = loadVideo(input_folder+filename + ".mp4");

if min_seq <= half_window
    min_seq = half_window+1;
end

D = computeDistances(video, n_frames, half_window, n_skip);

D = computeLocalMin(D, n_frames);

% Compute number of options per frame
min_cost = min(D(:));
threshold_cost = min_cost * threshold;
M = (D <= threshold_cost); % indices that satisfy threshold
D = D .* M; % distances based on threshold
D(isnan(D)) = Inf;
D(D==0) = Inf;
M = sum(M, 2); % number of jumps per frame
TF = islocalmax(M);
M = M .* TF;
jumpable_frames = sum(M>0);

% at_least_one_option = sum(M>=1);
% at_least_two_options = sum(M>=2);
% at_least_three_options = sum(M>=3);

if jumpable_frames == 0
    fprintf('No cuts found');
    return; % exit program
end

list_frames = 1:min_seq;

% Find cuts
count = 0;
for i = 1:max_cuts
    [rows, cols, n_cuts_response] = findCuts(list_frames, D, M, n_frames, n_jump_options);
    if numel(rows) > 0
        fprintf('Found cut %d/%d\n', i, max_cuts);
    end
    copy_rows = rows;
    copy_cols = cols;
    rows = [];
    cols = [];
    last_value = -min_seq*2;
    j = 1;
    while j <= length(copy_rows) % get valid jumps that are not too close to each other
        rows = [rows; copy_rows(j)];
        cols = [cols; copy_cols(j)];
        
        %indices = abs(copy_rows - copy_rows(j)) <= min_seq;
        
        indices = [];
        for k = j+1 : length(copy_rows)
            if copy_rows(k) == rows(end)
                %if abs(copy_cols(k) - copy_cols(j)) <= min_seq
                if sum(abs(copy_cols(k) - cols(j:end)) <= min_seq) > 0
                    indices = [indices; k];
                else
                    rows = [rows; copy_rows(k)];
                    cols = [cols; copy_cols(k)];
                    indices = [indices; k];
                end
            elseif abs(copy_rows(k) - copy_rows(j)) <= min_seq
                indices = [indices; k];
            end
        end
        
        copy_rows(indices) = [];
        copy_cols(indices) = [];
        j = j+1;
        
    end
    %rows(1) = 26; % 28 29 8 18
    %cols(1) = 6; % 7 8 3 13
    n_cuts_options_response = numel(rows);
    if n_cuts_options_response == 0
        fprintf('No more cuts available');
        break; % gets out of loop to start rendering
    end
    
    if n_cuts_options_response >= n_jump_options
        count = count + 1;
        [next_jumpable_frame, next_idx] = min(rows(:,find((all(rows>list_frames(end))),1)));
        
        if user_input
            % Render current list of frames
            current_frame_end = next_jumpable_frame + min_seq;
            if current_frame_end > n_frames
                current_frame_end = n_frames;
            end
            render([list_frames list_frames(end)+1:current_frame_end], video, jumps_folder+"0_current", half_window, use_cross_fading, false);

            for k = 1:n_cuts_options_response
                % Render before option
                render([list_frames list_frames(end)+1:rows(k)], video, jumps_folder+string(k)+"_before", half_window, use_cross_fading, false);

                % Render option
                render(cols(k):cols(k)+min_seq, video, jumps_folder+string(k)+"_option", half_window, use_cross_fading, false);
            end
            
            % Ask user for the chosen option
            op = -1;
            while op < 0 || op > n_cuts_options_response
                op = input("Choose option inside 'jump' folder (0: no cuts; 1-"+string(n_cuts_options_response)+" for cuts): ");
            end
            
            % Synthesize option
            list_frames = synthesis(list_frames, n_frames, rows(op), cols(op), min_seq);
        else
            % Randomize options
            id = randi(n_cuts_options_response);
            list_frames = synthesis(list_frames, n_frames, rows(id), cols(id), min_seq);
            %list_frames = synthesis(list_frames, n_frames, rows(2), cols(2), min_seq);
        end
        
    end
end

if should_finish_at_last_frame
    list_frames = [list_frames list_frames(end)+1:n_frames];
end

if count > 0
    % Render/save final video
    render(list_frames, video, output_folder+filename, half_window, use_cross_fading, true);
else
    fprintf('No jumps with %d options were found\n', n_jump_options);
end

% Save video
% saveVideo(video, n_frames, output_folder+filename);

