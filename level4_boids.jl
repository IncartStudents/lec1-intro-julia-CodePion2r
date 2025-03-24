module Boids
using Plots

mutable struct Boid
    position::Tuple{Float64, Float64}
    velocity::Tuple{Float64, Float64}
end

mutable struct WorldState
    boids::Vector{Boid}
    height::Float64
    width::Float64

    function WorldState(n_boids, width, height)
        boids = [Boid((rand() * width, rand() * height), (rand() * 2 - 1, rand() * 2 - 1)) for _ in 1:n_boids]
        new(boids, height, width)
    end
end

function update!(state::WorldState)
    for boid in state.boids
        # Обновление позиции и скорости птички
        boid.velocity = (boid.velocity[1] + rand() * 0.1 - 0.05, boid.velocity[2] + rand() * 0.1 - 0.05)
        boid.position = (boid.position[1] + boid.velocity[1], boid.position[2] + boid.velocity[2])

        # Обработка выхода за границы экрана
        wrap_around!(boid, state.width, state.height)
    end
end

function wrap_around!(boid::Boid, width::Float64, height::Float64)
    if boid.position[1] < 0
        boid.position = (boid.position[1] + width, boid.position[2])
    elseif boid.position[1] > width
        boid.position = (boid.position[1] - width, boid.position[2])
    end

    if boid.position[2] < 0
        boid.position = (boid.position[1], boid.position[2] + height)
    elseif boid.position[2] > height
        boid.position = (boid.position[1], boid.position[2] - height)
    end
end

function main()
    w = 30.0
    h = 30.0
    n_boids = 10

    state = WorldState(n_boids, w, h)

    anim = @animate for time in 1:100
        update!(state)
        boids_positions = [boid.position for boid in state.boids]
        scatter(boids_positions, xlim=(0, state.width), ylim=(0, state.height), label="")
    end
    gif(anim, "boids.gif", fps=10)
end

export main

end

using .Boids
Boids.main()