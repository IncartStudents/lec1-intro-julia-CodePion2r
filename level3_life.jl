
module GameOfLife
using Plots

mutable struct Life
    current_frame::Matrix{Int}
    next_frame::Matrix{Int}
end

function step!(state::Life)
    curr = state.current_frame
    next = state.next_frame
    n, m = size(curr)

    for i in 1:n
        for j in 1:m
            live_neighbors = 0
            for di in -1:1
                for dj in -1:1
                    if di == 0 && dj == 0
                        continue
                    end
                    ni = mod1(i + di, n) 
                    nj = mod1(j + dj, m)
                    live_neighbors += curr[ni, nj]
                end
            end

            if curr[i, j] == 1
                next[i, j] = (live_neighbors == 2 || live_neighbors == 3) ? 1 : 0
            else
                next[i, j] = (live_neighbors == 3) ? 1 : 0
            end
        end
    end

    state.current_frame .= next
    return nothing
end

function (@main)(ARGS)
    n = 30
    m = 30
    init = rand(0:1, n, m)

    game = Life(init, zeros(Int, n, m))

    anim = @animate for time = 1:100
        step!(game)
        cr = game.current_frame
        heatmap(cr, color=:grays, c=:auto)
    end
    gif(anim, "life.gif", fps = 10)
end

export main

end

using .GameOfLife
GameOfLife.main("")