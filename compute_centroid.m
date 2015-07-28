%Purpose: Get a centroid for a list of locations as described in Geisler,
%Perry, & Najemnik (2006), this code covers part one of the algorithm
%described in Appendix A
%Inputs:    P: an nx2 list of eye positions (x,y) in degrees
%           d_t: the period of time elapsed for each record in P (in
%           seconds)
%           i: the current index for the fixation detection algorithm
%Outputs:   k: index value for how many steps from i must be taken in order
%           to fill a 75 ms time bin
%           P_prime: the eye position data from i until i+k
%           time: vector of times between data points from i until i+k
%           C: the centroid of P_prime
%           done: 0 if more eye position data is available, otherwise 1
function [k, P_prime, time, C, done] = compute_centroid(P, d_t, i)
done = 0;                                               %Set done to zero
if i > size(P,1)                                        %If i is greater than the size of P
    k = []; P_prime = []; time = []; C = []; done = 1;  %Set done to 1 (true) and make empty vectors for other output values
else                                                    %Otherwise
    k = 0;                                              %Set k to zero
    this_time = 0;                                      %Set the time that has elapsed to zero
    while this_time < 0.075                             %While the elapsed time is less than 75 ms
        k = k + 1;                                      %Increment k
        if (i + k) > size(P,1)                          %If the incremented value is greater than the size of P
            k = []; P_prime = []; time = []; C = []; done = 1;%Set done to 1, empty vectors for other outputs, and return
            break
        else
            this_time = this_time + d_t(i + k);         %Otherwise, add the current time to the total time
        end
    end
end

if ~done                        %If there is more eye position data
   P_prime = P(i:i + k,:);      %P_prime gets P from i until i+k
   time = d_t(i + 1:i + k);     %time gets the time stamps from i until i+k
   C = mean(P_prime);           %Calculate the centroid of P_prime
end