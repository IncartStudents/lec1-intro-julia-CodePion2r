module Boids
using Plots
using LinearAlgebra

mutable struct Boid
    position::Vector{Float64}
    velocity::Vector{Float64}
    Boid(pos, vel) = new(pos, vel./norm(vel))
end

struct World
    boids::Vector{Boid}
    width::Float64
    height::Float64
    max_speed::Float64
    max_force::Float64
    perception::Float64
    separation_dist::Float64
end

function World(n=50; 
              width=100.0, height=100.0,
              max_speed=2.0, max_force=0.5,
              perception=50.0, separation_dist=25.0)
    boids = [Boid([rand()*width, rand()*height], 
            0.5max_speed.*randn(2)) for _ in 1:n]
    World(boids, width, height, max_speed, max_force, perception, separation_dist)
end
function limit_force!(vector, max_force)
    norm_vec = norm(vector)
    norm_vec > max_force && (vector ./= norm_vec/max_force)
    return vector
end

function find_neighbors(boid::Boid, world)
    neighbors = Boid[]
    for other in world.boids
        other === boid && continue
        distance = norm(boid.position - other.position)
        distance < world.perception && push!(neighbors, other)
    end
    neighbors
end

function cohesion(boid::Boid, neighbors, world)
    isempty(neighbors) && return zeros(2)
    center = sum(n.position for n in neighbors) / length(neighbors)
    desired = center - boid.position
    desired = desired ./ norm(desired) .* world.max_speed
    steer = desired - boid.velocity
    return limit_force!(steer, world.max_force)
end

function separation(boid::Boid, neighbors, world)
    steering = zeros(2)
    for other in neighbors
        diff = boid.position - other.position
        distance = norm(diff)
        distance < world.separation_dist && (steering += diff / (distance^2))
    end
    norm(steering) > 0 && (steering = steering ./ norm(steering) .* world.max_speed)
    steer = steering - boid.velocity
    return limit_force!(steer, world.max_force)
end

function alignment(boid::Boid, neighbors, world)
    isempty(neighbors) && return zeros(2)
    avg_velocity = sum(n.velocity for n in neighbors) / length(neighbors)
    desired = avg_velocity ./ norm(avg_velocity) .* world.max_speed
    steer = desired - boid.velocity
    return limit_force!(steer, world.max_force)
end

function soft_borders!(boid::Boid, world, margin=50.0, factor=0.1)
    turn = zeros(2)
    w, h = world.width, world.height
    
    if boid.position[1] < margin
        turn[1] += factor
    elseif boid.position[1] > w - margin
        turn[1] -= factor
    end
    
    if boid.position[2] < margin
        turn[2] += factor
    elseif boid.position[2] > h - margin
        turn[2] -= factor
    end
    
    boid.velocity += turn
end

function update!(world::World)
    for boid in world.boids
        neighbors = find_neighbors(boid, world)
        
        coh = cohesion(boid, neighbors, world)
        sep = separation(boid, neighbors, world)
        ali = alignment(boid, neighbors, world)
        
        boid.velocity += coh + sep + ali
        
        speed = norm(boid.velocity)
        speed > world.max_speed && (boid.velocity ./= speed/world.max_speed)
        
        boid.position += boid.velocity
        
        soft_borders!(boid, world)
        
        boid.position[1] = mod(boid.position[1], world.width)
        boid.position[2] = mod(boid.position[2], world.height)
    end
end

function simulate(;nframes=200, fps=20)
    world = World(100, width=800.0, height=600.0, 
                max_speed=4.0, perception=80.0)
    
    anim = @animate for _ in 1:nframes
        update!(world)
        x = [b.position[1] for b in world.boids]
        y = [b.position[2] for b in world.boids]
        
        scatter(x, y, 
               xlim=(0, world.width), 
               ylim=(0, world.height),
               title="Boids",
               legend=false, 
               markersize=4,
               markercolor=:steelblue,
               markerstrokewidth=0.5,
               markerstrokecolor=:black,
               background_color=:white,
               grid=false,
               aspect_ratio=1,
               framestyle=:box)
    end
    
    gif(anim, "boids.gif", fps=fps)
end

end

using .Boids
Boids.simulate()