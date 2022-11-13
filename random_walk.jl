#= 
Random Walk in d Dimensions
Author: Rudolph Rodriguez
Date: November 2022
Class: University of Arizona PHYS 426: Thermodynamics and Statistical Mechanics

This code realizes a random walk in generalized d dimensions. The function rand_d_walk performs the random walk with an option for biases.
The number of steps to return to the origin is returned by rand_d_walk.
The function sample_walks runs a chosen number of random walks and returns an array of the number of steps
taken to return to the origin. 

A histogram is generated for the distribution given by sample_walks.
=#

using Plots # Library for plotting distribution
using StatsBase # Library for (biased) sampling from array 

#=
The function rand_d_walk performs a random walk in d dimensions. 
    
The number of steps to return to the origin is returned by rand_d_walk.

Arguments:
    prob: The probability to step in the positive direction. In one dimension on a number line, this
    would correspond to a step to the right. rand_d_walk automatically sets the probability to step
    in the negative direction to 1-prob.

    dim: The dimension of the walk. dim = 1 random walks on a number line,
    dim = 2 on a plane, etc.

    cutoff: If the number of steps exceeds the cutoff, the walk will terminate. This is particularly important
    for biased walks, as it's likely that the walk will never return to the origin.
=#

function rand_d_walk(prob, dim, cutoff)

    # We create an undefined array with the length of our dimension.
    # We take random samples of axis to choose a direction to walk in, when d >= 2.

    axis = Array{Int64}(undef, dim) 

    # The for loop sets axis = [1,2,3,4,...] with the length of the array = dim.

    for i in 1:dim
        axis[i] = i
    end

    direction = [1,-1] # We sample from the direction array to choose a direction.
    weights = [prob, 1-prob] # The weights array holds the probability biases to step in the positive/negative direction.
    position = zeros(dim) # We initiatize our position at the origin. The position array has length = dim. We can think of this as our current position vector.
    zero_vector = zeros(dim) # We set a 0 vector to compare with our position vector.
    N = 0 # Initialize number of steps to 0.

    #= 
    The below loop functions a d "do while" loop, which does not have a dedicated implementation in Julia.
    An "angle", meaning an axis to walk on, is sampled, followed by a sample for the direction (positive/negative) to step.
    The position vector is updated, and we check if our updated position is the origin.
    We also implement our step number cutoff to avoid infinite walks.
    =#
    while true 
            angle = sample(axis) # Choose an axis e.g. (x,y,z). This is an unbiased sample, each axis is equally likely.
            step = sample(direction, Weights(weights)) # Choose either positive or negative direction. This sample is biased by prob.
            position[angle] += step # Update our position vector.
            N+=1 # Increase step counter.
            if position == zero_vector # Check if position vector is at the origin. If so, break our of the while loop.
                break
            end
            if N > cutoff
                break
            end
    end
    return N+1
end

function sample_walks(walk_arr, size, prob, dim, cutoff)
    for i in 1:size
        M = rand_d_walk(prob, dim, cutoff)
        push!(walk_arr, M)
    end
    
    return walk_arr
end


p = 1/2 # Probability to step in the positive direction
N = 0 # N is step counter, initialized to 0
m = 100 # Number of random walks to perform for our distribution
cutoff = 1000 # Number of steps at which our random walk terminates
step_dist = [] # Initializing distribution of step sizes

#A = rand_d_walk(p,2, cutoff)

step_dist = sample_walks(step_dist, m, p, 1, cutoff)
histogram(step_dist)

#A = rand_d_walk(p, 1)
#print("number of steps\n")
#print(A)

#print(walk_dist)
#conv = length(walk_dist_filt)
#div = length(walk_dist)  - length(walk_dist_filt)
#print("div\n")
#print(div / length(walk_dist))

#histogram(walk_dist_filt)
#histogram(walk_dist_filtered, xlims = (0,100))


#walk_dist = sample_walks(walk_dist, m)

#walk_dist_filt = filter(x -> x ≠ 100002, walk_dist)

#print(walk_dist_filt)
