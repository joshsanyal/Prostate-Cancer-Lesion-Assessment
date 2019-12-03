i = 0;
for counter=1:44
    %% ADC
    i = i + 1;
    while i == 6 || i == 11 || i == 12 || i == 13 || i == 22 || i == 24 || i == 27 || i == 32 || i == 37 || i == 38 || i == 44 || i == 45 || i == 54 
        i = i + 1;
    end
    Features(counter,1) = feature(i).ADC.Roughness;
    Features(counter,2) = feature(i).ADC.InsM;
    Features(counter,3) = feature(i).ADC.Entropy;
    Features(counter,4) = feature(i).ADC.Eccent;
    Features(counter,5) = feature(i).ADC.Com;
    Features(counter,6) = feature(i).ADC.Pixvalue;
    
    for ii = 1:5
        Features(counter,6+ii) = feature(i).ADC.RDS(ii);
    end
    for ii = 1:59
        Features(counter,11+ii) = feature(i).ADC.LBP(ii);
    end
    for ii = 1:32
        Features(counter, 70 + ii) = feature(i).ADC.HistogramEdge(ii);
    end
    for ii = 1:32
        Features(counter, 102 + ii) = feature(i).ADC.HistogramLesion(ii);
    end
    for ii = 1:2
        Features(counter, 134 + ii) = feature(i).ADC.Diff(ii);
    end
    for ii = 1:2
        for iii = 1:14
            Features(counter, 136 + iii + 14*(ii-1)) = feature(i).ADC.GLCM(iii,ii);
        end
    end
    for ii = 1:5
        Features(counter, 164 + ii) = feature(i).ADC.EdgeSharpness(ii);
    end
    
    
    %% DWI
    
    Features(counter,169+1) = feature(i).DWI.Roughness;
    Features(counter,169+2) = feature(i).DWI.InsM;
    Features(counter,169+3) = feature(i).DWI.Entropy;
    Features(counter,169+4) = feature(i).DWI.Eccent;
    Features(counter,169+5) = feature(i).DWI.Com;
    Features(counter,169+6) = feature(i).DWI.Pixvalue;
    
    for ii = 1:5
        Features(counter,175+ii) = feature(i).DWI.RDS(ii);
    end
    for ii = 1:59
        Features(counter,175+5+ii) = feature(i).DWI.LBP(ii);
    end
    for ii = 1:32
        Features(counter, 175+64 + ii) = feature(i).DWI.HistogramEdge(ii);
    end
    for ii = 1:32
        Features(counter, 175+96 + ii) = feature(i).DWI.HistogramLesion(ii);
    end
    for ii = 1:2
        Features(counter, 175+128 + ii) = feature(i).DWI.Diff(ii);
    end
    for ii = 1:2
        for iii = 1:14
            Features(counter, 175+130 + iii + 14*(ii-1)) = feature(i).DWI.GLCM(iii,ii);
        end
    end
    for ii = 1:5
        Features(counter, 175+158 + ii) = feature(i).DWI.EdgeSharpness(ii);
    end
    
    
    %% T2
    
    Features(counter,338+1) = feature(i).T2.Roughness;
    Features(counter,338+2) = feature(i).T2.InsM;
    Features(counter,338+3) = feature(i).T2.Entropy;
    Features(counter,338+4) = feature(i).T2.Eccent;
    Features(counter,338+5) = feature(i).T2.Com;
    Features(counter,338+6) = feature(i).T2.Pixvalue;
    
    for ii = 1:5
        Features(counter,344+ii) = feature(i).T2.RDS(ii);
    end
    for ii = 1:59
        Features(counter,344+5+ii) = feature(i).T2.LBP(ii);
    end
    for ii = 1:32
        Features(counter, 344+64 + ii) = feature(i).T2.HistogramEdge(ii);
    end
    for ii = 1:32
        Features(counter, 344+96 + ii) = feature(i).T2.HistogramLesion(ii);
    end
    for ii = 1:2
        Features(counter, 344+128 + ii) = feature(i).T2.Diff(ii);
    end
    for ii = 1:2
        for iii = 1:14
            Features(counter, 344+130 + iii + 14*(ii-1)) = feature(i).T2.GLCM(iii,ii);
        end
    end
    for ii = 1:5
        Features(counter, 344+158 + ii) = feature(i).T2.EdgeSharpness(ii);
    end
end
