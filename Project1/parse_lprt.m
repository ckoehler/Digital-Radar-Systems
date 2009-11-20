% ==================
% = Parse the data =
% ==================
clear;
% 5 MHz sampling times 896us PRT = 4480 gates for the short PRT pulse
% 5 MHz sampling times 3,104us PRT = 15520 gates per pulse
num_short_gates = 4480;
num_gates = 15520;

% we have 5 * 18 = 90 azimuth angles
num_az = 90;

% and 15 pulses with 3.104us PRT
num_short_pulses = 44;
num_pulses = 15;

% that makes the range per gate (T_s*c)/2 ~30 m.
delr = 29.976;

% set minimum distance at 10km
r_min = 10500;

% build the set of azimuth angles, with 0 degrees being North, etc.
az_set = 45:num_az+45-1;

% elevation for the first sweep was 0.5 degrees
el = 0.5;

% date and time of the scan
scan_time = [2008 10 22 19 13 0];

% name of the radar
radar = 'PAR';

% open the file in little endian format
fid=fopen('parEast22Oct.bin', 'r', 'l');

% calculate data lengths to figure out what exactly to read
short_pulse_num_per_segment = 2 * num_az / 5 * num_short_gates * num_short_pulses;
long_pulse_num_per_segment  = 2 * num_az / 5 * num_gates * num_pulses;
total_pulses_per_segment    = short_pulse_num_per_segment + long_pulse_num_per_segment;

% read the first sweep out of the file
frewind(fid);
for ii=0:4
	fseek(fid, total_pulses_per_segment*ii+1, 'bof');	
	Y(long_pulse_num_per_segment*ii+1:long_pulse_num_per_segment*(ii+1)) = ...
		fread(fid, long_pulse_num_per_segment, 'uint16');
end

Y=Y';

% remove the 2 MSBs by dividing by 0x4000 and keeping
% the remainder, which will be bits 0-13.
Y = rem(Y, 16384);

% make a boolean array of data that should be negative
neg = (Y >= 8192);

% ...and convert that data to a signed number
Y(neg) = Y(neg) - 16384;

% convert the result into double precision
Y = double(Y);

% take evey pair of I and Q data and convert it to
% one complex number.
Y = Y(1:2:end) + j*Y(2:2:end);

% reshape the array into a gates x pulses x azimuth 3D matrix
Y = reshape(Y, num_gates, num_pulses, num_az);

% and permute that into the right order of azimuth x gates x pulse
Y = permute(Y, [3 1 2]);

% then deinterleave the azimuth angles and save in X
for ii=0:4
	X(ii*18+10,:,:) = Y(ii*18+1,:,:);
	X(ii*18+1,:,:)  = Y(ii*18+2,:,:);
	X(ii*18+11,:,:) = Y(ii*18+3,:,:);
	X(ii*18+2,:,:)  = Y(ii*18+4,:,:);
	X(ii*18+12,:,:) = Y(ii*18+5,:,:);
	X(ii*18+3,:,:)  = Y(ii*18+6,:,:);
	X(ii*18+13,:,:) = Y(ii*18+7,:,:);
	X(ii*18+4,:,:)  = Y(ii*18+8,:,:);
	X(ii*18+14,:,:) = Y(ii*18+9,:,:);
	X(ii*18+5,:,:)  = Y(ii*18+10,:,:);
	X(ii*18+15,:,:) = Y(ii*18+11,:,:);
	X(ii*18+6,:,:)  = Y(ii*18+12,:,:);
	X(ii*18+16,:,:) = Y(ii*18+13,:,:);
	X(ii*18+7,:,:)  = Y(ii*18+14,:,:);
	X(ii*18+17,:,:) = Y(ii*18+15,:,:);
	X(ii*18+8,:,:)  = Y(ii*18+16,:,:);
	X(ii*18+18,:,:) = Y(ii*18+17,:,:);
	X(ii*18+9,:,:)  = Y(ii*18+18,:,:);
end

% clear up all the temp vars and save the data to a file,
% so we don't have to process this stuff again.
clear Y;
clear fid;
clear ii;
clear L;
clear neg;

save par_el0.5_lprt.mat