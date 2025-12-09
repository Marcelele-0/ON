#=
Autor: Marcel Musiałek
Indeks: 279704
Skrypt testujący listę 4.
=#

import Pkg
Pkg.activate(".")
Pkg.instantiate()

include("Interpolacja.jl")
using .Interpolacja
using Printf
using Plots

function main()
    println("--- LISTA 4: TESTY IMPLEMENTACJI ---")
    
    # === TEST ZADAŃ 1, 2, 3 ===
    x_nodes = [-1.0, 0.0, 1.0]
    y_nodes = [0.0, 1.0, 6.0]
    
    println("\n1. Test ilorazów różnicowych (Zad 1)")
    fx = Interpolacja.ilorazyRoznicowe(x_nodes, y_nodes)
    println("   Obliczone ilorazy: ", fx)
    
    println("\n2. Test wartości wielomianu Newtona (Zad 2)")
    t = 2.0
    val = Interpolacja.warNewton(x_nodes, fx, t)
    @printf "   Wartość w t=%.1f: %.4f\n" t val
    
    println("\n3. Test postaci naturalnej (Zad 3)")
    a_coeffs = Interpolacja.naturalna(x_nodes, fx)
    println("   Obliczone współczynniki (od a0): ", a_coeffs)
    
    # === ZADANIE 4: RYSOWANIE I ZAPISYWANIE ===
    println("\n4. Generowanie wykresów (Zad 4)...")
    f_test(x) = abs(x) + 0.5 * x * sin(5 * x)
    
    println("   Tworzenie 'wykres_rownoodlegle.png'...")
    p1 = Interpolacja.rysujNnfx(f_test, -2.0, 2.0, 10; wezly=:rownoodlegle)
    savefig(p1, "wykres_rownoodlegle.png")
    
    println("   Tworzenie 'wykres_czebyszew.png'...")
    p2 = Interpolacja.rysujNnfx(f_test, -2.0, 2.0, 10; wezly=:czebyszew)
    savefig(p2, "wykres_czebyszew.png")
    
    println("\n--- KONIEC TESTÓW. Sprawdź pliki PNG w folderze. ---")
end

main()