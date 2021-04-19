% clc
% clear variables
% close all
% 
% %%%%%%%%%% PARAMETERS %%%%%%%%%%
% 
% filename = "wood";
half_window = 2;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% input_folder = "../input/";
% output_folder = "../output/";
% 
% % Load video
% [video, h, w, n_frames] = loadVideo(input_folder + filename + ".mp4");


D = computeDistances(video, n_frames, half_window);

% Save video
% file = VideoWriter(output_folder + filename, 'MPEG-4');
% open(file);
% for i = 1:n_frames
%     fprintf('Saving %d/%d\n', i, n_frames);
%     writeVideo(file, video(i).img);
% end
% close(file);

