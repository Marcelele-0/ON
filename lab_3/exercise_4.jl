#=
Autor: Marcel Musiałek
Indeks: 279704
Zadanie 4 (Lista 3): Testowanie metod iteracyjnych
Równanie: sin(x) - (0.5x)^2 = 0
=#

# Ładujemy nasz lokalny moduł
include("MiejscaZerowe.jl")
using .MiejscaZerowe
using Printf

function main()
    println("--- Zadanie 4: Rozwiązywanie f(x) = sin(x) - (0.5x)^2 = 0 ---")

    # 1. Definicja funkcji i jej pochodnej
    f(x) = sin(x) - (0.5 * x)^2
    pf(x) = cos(x) - 0.5 * x  # Pochodna: (sin x)' = cos x,  (-0.25x^2)' = -0.5x

    # 2. Parametry dokładności (z polecenia)
    # delta = 0.5 * 10^-5, epsilon = 0.5 * 10^-5
    delta = 0.5e-5
    epsilon = 0.5e-5
    maxit = 100 # Bezpieczny limit iteracji

    println("Wymagana dokładność: delta = $delta, epsilon = $epsilon\n")
    
    # --- Metoda 1: Bisekcja ---
    a, b = 1.5, 2.0
    (r, v, it, err) = mbisekcji(f, a, b, delta, epsilon)
    
    println("1. Metoda Bisekcji (przedział [$a, $b]):")
    if err == 0
        @printf "   Pierwiastek r = %.15f\n" r
        @printf "   Wartość f(r)  = %.15e\n" v
        println("   Iteracje      = $it")
    else
        println("   Błąd: Funkcja nie zmienia znaku na końcach przedziału.")
    end
    println("-"^60)

    # --- Metoda 2: Newtona ---
    x0_newton = 1.5
    (r, v, it, err) = mstycznych(f, pf, x0_newton, delta, epsilon, maxit)
    
    println("2. Metoda Newtona (x0 = $x0_newton):")
    if err == 0
        @printf "   Pierwiastek r = %.15f\n" r
        @printf "   Wartość f(r)  = %.15e\n" v
        println("   Iteracje      = $it")
    elseif err == 1
        println("   Błąd: Przekroczono limit iteracji.")
    elseif err == 2
        println("   Błąd: Pochodna bliska zeru.")
    end
    println("-"^60)

    # --- Metoda 3: Siecznych ---
    x0_sec, x1_sec = 1.0, 2.0
    (r, v, it, err) = msiecznych(f, x0_sec, x1_sec, delta, epsilon, maxit)
    
    println("3. Metoda Siecznych (x0 = $x0_sec, x1 = $x1_sec):")
    if err == 0
        @printf "   Pierwiastek r = %.15f\n" r
        @printf "   Wartość f(r)  = %.15e\n" v
        println("   Iteracje      = $it")
    else
        println("   Błąd: Przekroczono limit iteracji.")
    end
    println("="^60)
end

main()