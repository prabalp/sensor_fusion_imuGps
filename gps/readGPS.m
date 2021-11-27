function [time, lat, latD, lng, lndgD] = readGPS(s)
        
        %time request
        fprintf(s, 'T');

        %read time
        time = fscanf(s, '%f');

        % req latitude
        fprintf(s, 'A')

        lat = fscanf(s, '%f');

        fprintf(s, 'a');
        latD = fscanf(s, '%s');

        fprintf(s, 'O');
        lng = fscanf(s, '%f'),

        fprintf(s, 'o');
        lngD = fscanf(s, '%s');

end
