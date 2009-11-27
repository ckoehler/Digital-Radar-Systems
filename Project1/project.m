% ================
% = Map the data =
% ================
clear;

%  load data to plot
load par_el0.5_lprt.mat;

% employ a simple threshold noise filter to zero out noise
Radjusted = R0;
Rneg = Radjusted <= 1;
Radjusted(Rneg) = 0;

% now adjust for range in linear scale
Zlin = Radjusted .* r.^2;

% and convert to log scale (dBZ)
Z = 10*log10(Zlin);

% where the signal was 0 due to noise cancellation, the values
% in dBZ are -infinity. We look for those and set those back to 0.
Zneg = Z == -inf;
Z(Zneg) = 0;

% Now we calibrate the data for non-noise data only
C = 25;
Zstuff = Z > 0;
Z(Zstuff) = Z(Zstuff) - C;

% finally, we strip out the ground clutter right around the radar.
Z(:,1:1500) = 0;

% this chunk to the end plots the data
pcolor([x],[y],[abs(Z)]);
shading flat;
axis equal;
axis([-50 350 -350 350]);
% the next three lines adjust the color scale to make 0 -> black
cmap = colormap(jet);
cmap(1,:) = [0 0 0];
colormap(cmap);
colorbar;
title('Reflectivity factor @ 0.5 el');
xlabel('Range / km from radar center');
ylabel('Range / km from radar center');
caxis([0 60]);

% the next line is optional and does the map overlay. External libraries
% are required for this.
bmapover(gca,[],radar,{'OK'});