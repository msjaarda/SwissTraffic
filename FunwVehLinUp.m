% Experiments to see what bunching is like in VehLinUp
% VehLinUp is generated by MATSim, from the MATSimInput.xlsx parameters

clear
clc
close all
format long g

% Load file
% Columns: 
% 1 Cumm Axle Locations | 2 Axle Load Value (Car = 0) | 3 Vehicle # (by Lane) | 4 Lane | 5 Vehicle # (Global, 0 when not first axle)

% For these experiments we only really need the first axle of each vehicle
% Column 5 holds this info
% Means Column 2 will inform truck (> 0)

load('VehLinUpNoPlat.mat')
%load('VehLinUpNoPlat.mat')
%load('VehLinUp.mat')
Lane = 1;

VehL1 = VehLinUp(VehLinUp(:,5) > 0,:);
VehL1 = VehL1(VehL1(:,4) == Lane,:);

L = VehL1(:,2) > 0;

L(1) = 0;
L(end-1) = 0;
L(end) = 0;

% Computer total vehicles in stream
TotalVehicles = length(L);
% Compute total trucks in stream
TotalTrucks = sum(L);

% F is the number of trucks following each other
index = 0;

for F = 1:100
    
    count(F) = 0;
    fd = 0;
    
    % Step through the logical matrix of truck (1) vs car (0)
    for i = 1:TotalVehicles-F-2
        % check if sequence matches
        if sum(L(i:i+F+1) == [0 ones(1,F) 0]') == F+2
            % if sequence matches... add a counter
            count(F) = count(F)+1;
            if F ~= 1
                % if sequence matches calculate average InterVehicleDist
                fd(count(F)) = mean(VehL1(i+2:i+F,1));
                index = i;
            end
        end
    end
    
    followdist(F) = mean(fd);
    
    check = 1:F;
    if sum(check.*count) == TotalTrucks
        break
    end
    
end

% Get patterns

for i = 1:length(count)
    if i == length(count)
        fprintf('%i CAR %sCAR (%.2f%%)\n\n',count(i),repmat('T ',1,i),100*i*count(i)/TotalTrucks)
        tc(i) = (100*i*count(i)/TotalTrucks)*1/i;
    else
        fprintf('%i CAR %sCAR (%.2f%%)\n',count(i),repmat('T ',1,i),100*i*count(i)/TotalTrucks)
        tc(i) = (100*i*count(i)/TotalTrucks)*1/i;
    end
    countxp(i) = 100*i*count(i)/TotalTrucks;
end

TC = sum(tc)/100;
TT = 1 - TC;

countx = 0;

for i = 1:TotalVehicles-1
    if L(i) == 0
        if L(i+1) == 1
            countx = countx+1;
        end
    end
end

TotalCars = TotalVehicles - TotalTrucks;
CT = countx/TotalCars;
CC = 1-CT;

% Summary

fprintf('\nTotal Vehicles \t\t= %i\n',TotalVehicles)
fprintf('Total Trucks \t\t= %i (%.2f%%)\n',TotalTrucks,100*TotalTrucks/TotalVehicles)
fprintf('Truck-Truck \t\t= %.2f%%\n',TT*100)
fprintf('Lane \t\t\t\t= %i\n\n',Lane)

bar(countxp)


% Step 1: Use AnalyzeCountFile logic to find patterns in traffic!
% Step 2: Optimize and Implement into MATSim

% Goal is to see how much natural bunching we have with our bunching
% factor. Then we will know how to build platoons

% How to build platoons (from 12/09/19 meeting with Alain)
% 2 basic strategies...
% #1 Build from Scratch
%    Involves defining a truck type as a platoon probably
% #2 Modifying current traffic through swapping
%    Be sure to swap from random location
%    Could become overconstrained

% We must take into account that most platoons will feature similar
% vehicles, which are likely more than 2/3 full. Type 113 is a very common
% one, particuarly for intational routes like MC.

% We could start with just one vehicle type.

% Let's try a swapping routine right now... actually perhaps I need to do
% this prior... when we still have info about vehicle types



