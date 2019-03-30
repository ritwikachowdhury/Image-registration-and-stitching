function [descriptors, locs] = sift(img)
    % [descriptors, locs] = sift(img)
    %
    % This function returns IMAGE's SIFT keypoints.
    %   Input parameters:
    %     img: the image.
    %
    %   Output:
    %     descriptors: a K-by-128 matrix, where each row gives an invariant
    %         descriptor for one of the K keypoints.  The descriptor is a vector
    %         of 128 values normalized to unit length.
    %     locs: K-by-4 matrix, in which each row has the 4 values for a
    %         keypoint location (row, column, scale, orientation).  The 
    %         orientation is in the range [-PI, PI] radians.
    if (ndims(img) == 3)
       img = rgb2gray(img);
    end

    [rows, cols] = size(img); 

    % Convert into PGM imagefile
    f = fopen('tmp.pgm', 'w');
    if f == -1
        error('Could not create file tmp.pgm.');
    end
    fprintf(f, 'P5\n%d\n%d\n255\n', cols, rows);
    fwrite(f, img', 'uint8');
    fclose(f);

    % Evaluate the executable to get output file
    if isunix
        command = '!./sift ';
    else
        command = '!siftWin32 ';
    end
    command = [command ' <tmp.pgm >tmp.key'];
    eval(command);

    % Open tmp.key and check its header
    g = fopen('tmp.key', 'r');
    if g == -1
        error('Could not open file tmp.key.');
    end
    [header, count] = fscanf(g, '%d %d', [1 2]);
    if count ~= 2
        error('Invalid keypoint file beginning.');
    end
    num = header(1);
    len = header(2);
    if len ~= 128
        error('Keypoint descriptor length invalid (should be 128).');
    end

    % Creates the two output matrices (use known size for efficiency)
    locs = double(zeros(num, 4));
    descriptors = double(zeros(num, 128));

    % Parse tmp.key
    for i = 1:num
        [vector, count] = fscanf(g, '%f %f %f %f', [1 4]); %row col scale ori
        if count ~= 4
            error('Invalid keypoint file format');
        end
        locs(i, :) = vector(1, :);

        [descrip, count] = fscanf(g, '%d', [1 len]);
        if (count ~= 128)
            error('Invalid keypoint file value.');
        end
        % Normalize each input vector to unit length
        descrip = descrip / sqrt(sum(descrip.^2));
        descriptors(i, :) = descrip(1, :);
    end
    fclose(g);

    delete('tmp.pgm');
end
