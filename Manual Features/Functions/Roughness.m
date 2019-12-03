function ave_r = Roughness(ROI)
%COMPACTNESS Summary of this function goes here
%   Detailed explanation goes here


    structBoundaries = bwboundaries(ROI);
    xy=structBoundaries{1};
    x = xy(:, 2); % Columns.
    y = xy(:, 1); % Rows.
    
    measurements = regionprops(ROI, 'Centroid');
    si = size(measurements);
    if si(1) == 255 
        centerOfMass = measurements(255).Centroid;
    else
        centerOfMass = measurements.Centroid;
    end
  
    %Normalized radial length
    max_length = 0;

    [m,~] = size(x);
    D = zeros(m,1);
    for ii = 1:m
        G2 =[x(ii,1), y(ii,1)];
        D(ii)  = sqrt(sum((centerOfMass - G2) .^ 2));
        if D(ii) > max_length
            max_length = D(ii);
        end    
    end
    %figure, plot(D);
    D(ii)  = D(ii)./max_length;  
    
    %Radial signature
    Radial_signature = zeros(1,1);
    Radial_signature(1,1) = mean2(D); %mean of radial length 
    Radial_signature(1,2) = std(D); %SD 
    
    %Area ration parameter
    sum_ratio =0;
     for ii = 1:m
          sum_ratio = sum_ratio + (D(ii,1)- Radial_signature(1,1));
     end
     
     %boundary roughness
     k = 1; j =1;
     R = zeros(mod(m,25)+1,1);
     sum_ratio = 0;
     for ii = 1:(m-1)
          sum_ratio = sum_ratio + abs(D(ii,1)- D((ii+1),1));
          if k > 25
              k =1;
              R(j,1) = sum_ratio;
              j= j+1;
              sum_ratio =0;
          end  
          k = k+1;
     end
     ave_r = ((mod(m,25)+1)/m) * sum(R);

end
