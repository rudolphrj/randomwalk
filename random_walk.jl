using Plots
using StatsBase

function rand_d_walk(prob, d, cutoff)
    axis = Array{Int64}(undef, d)
    for i in 1:d
        axis[i] = i
    end

    direction = [1,-1]
    weights = [prob, 1-prob]
    position = zeros(d)
    zero_vector = zeros(d)
    N = 0
    while true 
            angle = sample(axis)
            step = sample(direction, Weights(weights))
            position[angle] += step
            N+=1
            if position == zero_vector
                break
            end
            if N > cutoff
                break
            end
    end
    return N+1
end

function rand_walk_2d(prob)
    axis = [1,2]
    direction = [1,-1]
    weights = [prob, 1-prob]
    displacement = [0,0]
    N = 0
    while true 
        angle = sample(axis)
        step = sample(direction, Weights(weights))
        displacement[angle] += step
        N+=1
        if displacement == [0,0]
            break
        end
        if N > 1000000
            break
        end
    end
    
    return N+1
end



function rand_walk(prob)
    axis = [1,2,3]
    direction = [1,-1]
    weights = [prob, 1-prob]
    displacement = 0
    N = 0
    while true 
        step = sample(direction, Weights(weights))
        displacement += step
        N+=1
        if displacement == 0
            break
        end
        if N > 100000
            break
        end
    end
    
    return N+1
end



function rand_walk_w_plot(prob)
    axis = [1,2,3]
    direction = [1,-1]
    weights = [prob, 1-prob]
    walk = [0]
    N = 0
    while true 
        step = sample(direction, Weights(weights))
        push!(walk, walk[end] + step)
        N+=1
        if walk[end] == 0
            break
        end
        if N > 100000
            break
        end
    end
    
    
    return N+1, walk
end

function sample_walks(walk_arr, size, prob, dim, cutoff)
    for i in 1:size
        M = rand_d_walk(prob, dim, cutoff)
        push!(walk_arr, M)
    end
    
    return walk_arr
end


p = 1/2
N = 0
m=10
cutoff = 10
walk_dist = []

A = rand_d_walk(p,2, cutoff)

#walk_dist = sample_walks(walk_dist, m, p, 2, cutoff)
#print("walk_dist\n")
#print(walk_dist)
#histogram(walk_dist)

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
