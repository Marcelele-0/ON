#=
Autor: Marcel Musiałek
Indeks: 279704
Moduł: Interpolacja
=#

module Interpolacja

using Plots

# TA LINIA JEST KLUCZOWA:
export ilorazyRoznicowe, warNewton, naturalna, rysujNnfx

function ilorazyRoznicowe(x::Vector{Float64}, f::Vector{Float64})
    n = length(f)
    fx = copy(f)
    for j in 2:n
        for i in n:-1:j
            fx[i] = (fx[i] - fx[i-1]) / (x[i] - x[i-j+1])
        end
    end
    return fx
end

function warNewton(x::Vector{Float64}, fx::Vector{Float64}, t::Float64)
    n = length(fx)
    nt = fx[n]
    for i in (n-1):-1:1
        nt = fx[i] + (t - x[i]) * nt
    end
    return nt
end

function naturalna(x::Vector{Float64}, fx::Vector{Float64})
    n = length(fx)
    a = copy(fx)
    for k in (n-1):-1:1
        for i in k:(n-1)
            a[i] = a[i] - x[k] * a[i+1]
        end
    end
    return a
end

function rysujNnfx(f, a::Float64, b::Float64, n::Int; wezly::Symbol=:rownoodlegle)
    nodes_x = Vector{Float64}(undef, n+1)
    
    if wezly == :rownoodlegle
        h = (b - a) / n
        for k in 0:n
            nodes_x[k+1] = a + k * h
        end
    elseif wezly == :czebyszew
        for k in 0:n
            nodes_x[k+1] = 0.5 * (a + b) + 0.5 * (b - a) * cos((2.0 * k + 1.0) / (2.0 * (n + 1)) * pi)
        end
    end
    
    nodes_y = f.(nodes_x)
    diffs = ilorazyRoznicowe(nodes_x, nodes_y)
    
    plot_x = range(a, b, length=max(100, n * 10))
    true_y = f.(plot_x)
    poly_y = [warNewton(nodes_x, diffs, t) for t in plot_x]
    
    p = plot(plot_x, true_y, label="f(x)", linewidth=2, title="Interpolacja (n=$n, $wezly)")
    plot!(p, plot_x, poly_y, label="Wielomian N_n(x)", linestyle=:dash, linewidth=2)
    scatter!(p, nodes_x, nodes_y, label="Wezly", markersize=4)
    
    display(p)
    return p
end

end # module