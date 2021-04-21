function [rows, cols, n_cuts_response] = findCuts(list_frames, D, M, n_frames, n_cuts_request)


[min_costs, indices] = mink(D(:), n_cuts_request);

n_cuts_response = length(indices);

[rows, cols] = ind2sub([n_frames n_frames], indices);

last_frame = list_frames(end);
valid_indices = (rows > last_frame);
rows = rows(valid_indices);
cols = cols(valid_indices);

end

