% ================
% = Map the data =
% ================
P1 = pow;

figure(1)
% % now plot the result.
% pcolor([x],[y],[P1]);
% shading flat;
% axis equal;
% axis([-350 350 -350 350]);
% colormap(jet);
% colorbar;
% caxis([0 60]);


% now adjust for range to get reflectivity
C = 20;
Z = P1 + 20*log10(r) - C;

figure(2);
pcolor([x],[y],[abs(Z)]);
shading flat;
axis equal;
axis([-350 350 -350 350]);
colormap(jet);
colorbar;
title('Reflectivity factor @ 0.5 el');
caxis([0 60]);