function [D] = computeLocalMin(D, n_frames)


D = padarray(D, [1 1], Inf);

TF = zeros(size(D));

for i = 1 : n_frames+2
    TF(i,:) = islocalmin(D(i,:));
end

D = D .* TF;

D = D(2:end-1, 2:end-1);
D(D==0) = Inf;
D(isnan(D)) = Inf;

end

