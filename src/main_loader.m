clc
clear variables
close all

%%%%%%%%%% PARAMETERS %%%%%%%%%%

filename = "clock";

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

input_folder = "../input/";
output_folder = "../output/";

% Load video
[video, h, w, n_frames] = loadVideo(input_folder + filename + ".mp4");