% ================
% = Map the data =
% ================

% convert our cylindrical coordinates of angle and range into rectangular ones
% for plotting
el_rad = el/180*pi; 
[r,az_rad] = meshgrid(([0:num_gates-1]*delr+r_min)/1e3,az_set/180*pi); 
x = r*cos(el_rad).*sin(az_rad); 
y = r*cos(el_rad).*cos(az_rad); 
z = r*sin(el_rad);

% multiply each gate per az per pulse with its complex conjugate to get power,
% then take the mean across all pulses. Save the result in a num_az x num_gates matrix and
% convert to dB.
R0=mean(X(:,:,1:num_pulses).*conj(X(:,:,1:num_pulses)),3);
pow=10*log10(R0);


figure(1)
% now plot the result.
pcolor([x],[y],[pow]);
shading flat;
axis equal;
axis([-150 150 -150 150]);
colormap(jet);
colorbar;


% now adjust for range to get reflectivity
C = 50;
Z = 10*log10(R0) + 20*log10(r) - C;
figure;
pcolor([x],[y],[abs(Z)]);
shading flat;
axis equal;
axis([-120 120 -120 120]);
colormap(jet);
colorbar;
title('Reflectivity factor @ 0.44 el');
caxis([0 60]);