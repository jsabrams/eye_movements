%Purpose: get the fixation points and durations from eye position data
%based on the algorithm described in Geisler, Perry, and Najemnik (2006)
%Inputs:    P: an nx2 matrix of (x,y) eye position data
%           d_t: an nx1 vector of elapsed time between samples for the
%           matrix P
%           a: maximum standard deviation in distances from the centroid in
%           degrees for a series of eye positions for that series to be 
%           considered the a potential fixation
%           b: maximum distance in degrees between an existing centroid and
%           a new data point for that data point to be considered part of
%           the same fixation as the centroid
%           c: minimum distance in degrees between an existing centroid and
%           a new data point for that data point to be ruled out as
%           belonging to the fixation represented by the centroid
%Outputs:   F: an nx2 matrix of (x,y) positions for fixations
%           times: an nx1 vector of times for each fixation in ms
function [F, times] = get_fixations(P, d_t, a, b ,c)

F = [];                                                         %Set an empty matrix for the fixations
times = [];                                                     %Set an empty matrix for the times
i = 1;                                                          %Set i to 1
while i <= size(P,1)                                            %While there is still eye positon data
    [k, P_prime, time, C, done] = compute_centroid(P, d_t, i);  %Compute centroid for possible fixation (P_prime), this is Part 1 of the algorithm
    if done                                                     %If done returns true, break
        break                                                  
    end                                                        
    
    sigma = compute_sigma(P_prime, C);                          %Get the standard deviation of the points in P_prime from the centroid, C (this is Part 2)
    if sigma < a                                                %If the standard deviation is less than a
        i = i + k;                                              %Set i to i+K (this is Part 3)        
        while i <= size(P,1)                                	%While there are still eye positions (this is the start of Part 4)
            this_p = P(i,:);                                    %Get a new point from the matrix of eye position data
            dist = compute_dist(this_p, C);                     %Compute the distance between that point and the centroid of P_prime   
            if dist < b                                         %If that distance is less than b
                P_prime = [P_prime; this_p];                    %Add that point to P_prime
                time = [time; d_t(i)];                          %Add the time elapsed to the vector time
                i = i + 1;                                      %Increment i, if the end hasn't been reached
            elseif dist > c                                     %If that distance is greater than c (this is Part 5)
                F = [F; mean(P_prime)];                         %Compute the centroid of P_prime and set it as a fixation
                times = [times; sum(time)];                     %Add the sum of the time vector to the list of fixation times
                break                                           %Break up to Part 1
            else                                                %If that distance is greater than or equal to b but less than or equal to c (Part 6)
                T = this_p;                                     %Set a new vector T with the current point 
                tm = 0;                                         %Set a time keeping variable, tm, to zero
                while tm < 0.05                                 %While tm is less than 50 ms (Part 7)
                    i = i + 1;                                  %Increment i
                    if i > size(P,1)                            %If there isn't any more eye position data
                        break                                   %Break up to Part 1
                    end                                         
                    this_p = P(i,:);                            %Get the eye position at i
                    tm = tm + d_t(i);                           %Add the change in time
                    if tm < 0.05                                %If the total time is less than 50 ms
                        T = [T; this_p];                        %Add that eye position to T
                    end                                         
                end                                             
                if i < size(P,1)                                %If there are still eye positions (Part 8)
                    C_t = mean(T);                              %Get the centroid of T
                    dist = compute_dist(C_t, C);                %Get the distance between that centroid and the centroid of P_prime
                    if dist < b                                 %If that distance is less than b
                        P_prime = [P_prime; C_t];               %Add the centroid of T to P_prime
                        time = [time; tm];                      %Add the time elapsed during T to the time vector
                    else                                        %If the distance is greater than b, T is a break from the fixation in P_prime
                        F = [F; mean(P_prime)];                 %Record the centroid of P_prime as a fixation
                        times = [times; sum(time)];             %Record the time spent during P_prime
                        break                                   %Break up to Part 1
                    end                                        
                end
            end
        end
        
        if i >= size(P,1)                               %If the end of the eye movement data has been reached
            F = [F; mean(P_prime)];                     %Add P_prime as a fixation
            times = [times; sum(time)];                 %Add the time
        end
    end
    i = i + 1;                                          %If sigma is greater than a, then P_prime doesn't contain the start of a fixation (Part 2)
end