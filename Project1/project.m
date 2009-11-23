% ================
% = Map the data =
% ================
clear;
load par_el0.5_lprt.mat;
P1 = pow;

figure(1)
% now plot the result.
pcolor([x],[y],[P1]);
shading flat;
axis equal;
axis([-350 350 -350 350]);
colormap(jet);
colorbar;
caxis([0 60]);


% now adjust for range to get reflectivity
Radjusted = R0;
Rneg = Radjusted <= 1;
Radjusted(Rneg) = 0;

Zlin = Radjusted .* r.^2;

Z = 10*log10(Zlin);
Zneg = Z == -inf;
Z(Zneg) = 0;
Zstuff = Z > 0;
C = 25;

Z(Zstuff) = Z(Zstuff) - C;
Z(:,1:1500) = 0;

figure(2);
pcolor([x],[y],[abs(Z)]);
shading flat;
axis equal;
axis([-350 350 -350 350]);
colormap(jet);
colorbar;
title('Reflectivity factor @ 0.5 el');
caxis([0 60]);