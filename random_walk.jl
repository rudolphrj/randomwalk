#= 
Random Walk in d Dimensions
Author: Rudolph J. Rodriguez
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



function rand_d_walk(prob, dim, cutoff)

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
            if N > cutoff # Terminates the loop if step number exceeds cutoff. Prevents infinite walks.
                break
            end
    end
    return N # Returns number of steps taken to return to origin.
end



function sample_walks(step_arr, size, prob, dim, cutoff)

    #=
    sample_walks loops through rand_d_walk a chosen number of times, returning an array of step numbers taken to return to origin.

    Arguments:
        step_arr: array for step sizes
        size: number of walks to perform
        prob, dim, cutoff: arguments for rand_d_walk, use described in documentation for rand_d_walk.
    =#

    # For loop performs rand_d_walks, number of walks according to size argument.
    for i in 1:size
        M = rand_d_walk(prob, dim, cutoff) # Performs random walk.
        push!(step_arr, M) # Pushes step number to array.
    end
    
    return step_arr # Returns array of step numbers.
end

function prob_convergence(step_arr, step_arr_filt)

    num_converge = length(step_arr_filt) # Number of walks that return to origin
    num_diverge = length(step_arr) - length(step_arr_filt) # Number of walks that diverge (reach cutoff)
    prob_converge = num_converge / length(step_arr) # Probability for walk to return to origin.

    return num_converge, num_diverge, prob_converge
end

function plot_distribution(dist, dim)

    max_step = maximum(dist)
    xlim_max = mean(dist)
    plt = histogram(step_dist_filt, title = "Distribution of Random Walks in $dim Dimension(s)", xlabel="Number of steps", ylabel= "Number of times walk returns to origin", xlims = (0,xlim_max))

    log_plt = histogram(step_dist_filt, title = "Distribution of Random Walks in $dim Dimension(s) (Log)", xlabel="Number of steps", ylabel= "Number of times walk returns to origin (Log)", xlims = (0,max_step), yaxis=:log)


    return plt, log_plt
end

function print_walk_stats(size, dim, prob, conv, div, prob_conv)
    print("$size samples of $dim dimensional random walks complete for p = $prob.\n$conv walks returned to the origin\n$div walks did not return to the origin\nThere was a $prob_conv probability for a walk to return to the origin.\n\n")
end

p = 1/2 # Probability to step in the positive direction
m = 500 # Number of random walks to perform for our distribution
cutoff = 100000 # Number of steps at which our random walk terminates

for d in [1,2,3,6]
    N = 0 # N is step counter, initialized to 0
    step_dist = [] # Initializing distribution of step sizes
    step_dist_filt = []
    step_dist = sample_walks(step_dist, m, p, d, cutoff)
    step_dist_filt = filter(x -> x ≠ cutoff + 1, step_dist) # Removes entries where step number = cutoff
    conv, div, prob_conv = prob_convergence(step_dist, step_dist_filt)
    print_walk_stats(m, d, p, conv, div, prob_conv)
    plt, log_plt = plot_distribution(step_dist_filt, d)
    display(plt)
    display(log_plt)
end
