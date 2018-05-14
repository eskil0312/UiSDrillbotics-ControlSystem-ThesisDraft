clear all 
close all
clc



load('2018-05-06_well1_automation_mode_600Hz')

t = Channel_1_Data(50000:294992,:);   % [s]

WOB = Channel_8_Data(50000:294992,:); % [Kg]
RPM = Channel_5_Data(50000:294992,:); % [RPM]
T = Channel_6_Data(50000:294992,:);   % [Nm]
D = Channel_7_Data(50000:294992,:);   % [cm]
Z1 = Channel_2_Data(50000:294992,:);  % [g]
Z2 = Channel_3_Data(50000:294992,:);  % [g]
Z3 = Channel_4_Data(50000:294992,:);  % [g]

% Constants in the model
d_bit = 1.125*0.0254; % Bit diameter [m]
g = 9.81;             % Convertion from Kg to N
S = 1200;             % Sampling rate 300Hz


% Introducing median filters
median_RPM = medfilt1(RPM,100);
median_WOB = medfilt1(WOB,150);
median_T = medfilt1(T,100);



% Maximum values from the drilling operation
Duration = max(t)/60; % Duration [min]
PeakLoad = max(WOB); % [Kg]
PeakTorque = max(T); % [Nm]
Depth = max(D); %[cm]




% ROP Calculations
dt = 60; % Window length [s]
dx = dt*S; % Traveled length during dt

for i = dx:length(t-dx)
    ROP(i) =  ((D(i)-D(i+1-dx))/dt)*60; % [cm/min]
end

ROP = ROP'; 
median_ROP = medfilt1(ROP,250);



R = 1; % Number of rows in the subplot
C = 3; % Number of columns in the subplot
yaxis = t/60;

figure (5)

subplot(R,C,1)
plot(med_WOB,yaxis,'b')
xlabel('WOB [Kg]')
ylabel('Time[min]')
set(gca, 'YDir','reverse')
set(gca,'xaxisLocation','top')
WOB_max = 35;
line([WOB_max WOB_max],[min(yaxis) max(yaxis)],'Color','r','LineStyle','--')
legend('WOB','Limit','Location','S')
xlim([-5 40])
ylim([min(yaxis) max(yaxis)])

subplot(R,C,2)
plot(med_RPM,yaxis,'k')
xlabel('RPM')
ylabel('Time[min]')
xlim([0 2000])
ylim([min(yaxis) max(yaxis)])
set(gca, 'YDir','reverse')
set(gca,'xaxisLocation','top')

subplot(R,C,3)
plot(med_ROP,yaxis,'g')
xlabel([num2str(dt),'s ROP [cm/60s]'])
ylabel('Time[min]')
set(gca, 'YDir','reverse')
set(gca,'xaxisLocation','top')
line([mean(ROP) mean(ROP)],[min(yaxis) max(yaxis)],'Color','k')
xlim([-1 5.5])
ylim([min(yaxis) max(yaxis)])
legend('ROP','Mean','Location','S')


suptitle('Autonomous mode, time based')


