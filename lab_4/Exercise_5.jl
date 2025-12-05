#=
Autor: Marcel Musiałek
Indeks: 279704
Zadanie 5 (Lista 4): Testowanie funkcji rysujNnfx
=#

import Pkg
Pkg.activate(".")

include("Interpolacja.jl")
using .Interpolacja
using Plots

function main()
    println("--- Zadanie 5: Testowanie interpolacji ---")

    # --- Podpunkt (a): f(x) = e^x na [0, 1] ---
    println("\nGenerowanie wykresów dla (a): f(x) = e^x, [0, 1]")
    f1(x) = exp(x)
    a1, b1 = 0.0, 1.0
    
    for n in [5, 10, 15]
        println("   Rysowanie dla n = $n...")
        p = rysujNnfx(f1, a1, b1, n; wezly=:rownoodlegle)
        
        # Dodajemy tytuł specyficzny dla zadania
        title!(p, "Zad 5a: e^x, n=$n (rownoodlegle)")
        
        # Zapisujemy do pliku
        filename = "zad5_a_n$(n).png"
        savefig(p, filename)
        println("   Zapisano: $filename")
        
        # Opcjonalnie wyświetlamy w VS Code
        display(p)
    end

    # --- Podpunkt (b): f(x) = x^2 * sin(x) na [-1, 1] ---
    println("\nGenerowanie wykresów dla (b): f(x) = x^2 * sin(x), [-1, 1]")
    f2(x) = x^2 * sin(x)
    a2, b2 = -1.0, 1.0
    
    for n in [5, 10, 15]
        println("   Rysowanie dla n = $n...")
        p = rysujNnfx(f2, a2, b2, n; wezly=:rownoodlegle)
        
        title!(p, "Zad 5b: x^2 sin(x), n=$n (rownoodlegle)")
        
        filename = "zad5_b_n$(n).png"
        savefig(p, filename)
        println("   Zapisano: $filename")
        
        display(p)
    end
    
    println("\n--- Koniec Zadania 5 ---")
end

main()