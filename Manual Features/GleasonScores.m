%% Gleason Score Vector

i = 0;
for counter=1:44
    
    i = i + 1;
    while i == 6 || i == 11 || i == 12 || i == 13 || i == 22 || i == 24 || i == 27 || i == 32 || i == 37 || i == 38 || i == 44 || i == 45 || i == 54 
        i = i + 1;
    end
    
    if (strcmp(Patient(i).truth,'High'))
        Gleason(counter) = 1;
    else
        Gleason(counter) = 0;
    end
end