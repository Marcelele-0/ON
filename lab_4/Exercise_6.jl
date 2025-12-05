#=
Autor: Marcel Musiałek
Indeks: 279704
Zadanie 6 (Lista 4): Zjawisko Rungego i zbieżność interpolacji
=#

import Pkg
Pkg.activate(".")

include("Interpolacja.jl")
using .Interpolacja
using Plots

function main()
    println("--- Zadanie 6: Testowanie zjawiska Rungego i zbieżności ---")

    # --- Podpunkt (a): f(x) = |x| na [-1, 1] ---
    println("\n1. Analiza f(x) = |x| na [-1, 1]")
    f1(x) = abs(x)
    a1, b1 = -1.0, 1.0
    
    for n in [5, 10, 15]
        println("   Generowanie n = $n...")
        
        # Równoodległe
        p1 = rysujNnfx(f1, a1, b1, n; wezly=:rownoodlegle)
        title!(p1, "Zad 6a: |x|, n=$n (Rownoodlegle)")
        savefig(p1, "zad6_a_n$(n)_rown.png")
        
        # Czebyszew
        p2 = rysujNnfx(f1, a1, b1, n; wezly=:czebyszew)
        title!(p2, "Zad 6a: |x|, n=$n (Czebyszew)")
        savefig(p2, "zad6_a_n$(n)_czeb.png")
    end

    # --- Podpunkt (b): f(x) = 1/(1+x^2) na [-5, 5] (Funkcja Rungego) ---
    println("\n2. Analiza f(x) = 1/(1+x^2) na [-5, 5] (Zjawisko Rungego)")
    f2(x) = 1.0 / (1.0 + x^2)
    a2, b2 = -5.0, 5.0
    
    for n in [5, 10, 15]
        println("   Generowanie n = $n...")
        
        # Równoodległe
        p3 = rysujNnfx(f2, a2, b2, n; wezly=:rownoodlegle)
        title!(p3, "Zad 6b: Runge, n=$n (Rownoodlegle)")
        savefig(p3, "zad6_b_n$(n)_rown.png")
        
        # Czebyszew
        p4 = rysujNnfx(f2, a2, b2, n; wezly=:czebyszew)
        title!(p4, "Zad 6b: Runge, n=$n (Czebyszew)")
        savefig(p4, "zad6_b_n$(n)_czeb.png")
    end
    
    println("\n--- Koniec Zadania 6. Wykresy zapisane. ---")
end

main()