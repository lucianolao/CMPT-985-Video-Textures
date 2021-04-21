% clc
% clear variables
% close all
% 
% %%%%%%%%%% PARAMETERS %%%%%%%%%%
 
% filename = "clock";
half_window = 2;
n_skip = 10; % skip n frames ahead and before (even number)
threshold = 1.5;


% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% input_folder = "../input/";
% output_folder = "../output/";
% 
% % Load video
% [video, h, w, n_frames] = loadVideo(input_folder+filename + ".mp4");


min_seq = half_window+1; % minimum number of frames in a sequence (without cuts)


D = computeDistances(video, n_frames, half_window, n_skip);

D = computeLocalMin(D, n_frames);

% Compute number of options per frame
min_cost = min(D(:));
threshold_cost = min_cost * threshold;
M = sum(D<= threshold_cost, 2);

list_frames = 1:min_seq;

% Find cuts
for i = 1:5
    [rows, cols, n_cuts_response] = findCuts(list_frames, D, M, n_frames, 3);
    rows(1) = 28; % 29 8 18
    cols(1) = 7; % 8 3 13
    list_frames = synthesis(list_frames, n_frames, rows(1), cols(1), min_seq);
end

% Render
render(list_frames, video, output_folder+filename, half_window);

% Save video
% saveVideo(video, n_frames, output_folder+filename);

