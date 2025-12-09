#=
Autor: Marcel Musiałek
Indeks: 279704
Zadanie 5 (Lista 3): Przecięcie wykresów y = 3x i y = e^x
Równoważne znalezieniu zera funkcji f(x) = 3x - e^x.
Metoda: Bisekcja.
=#

include("MiejscaZerowe.jl")
using .MiejscaZerowe
using Printf

function main()
    println("--- Zadanie 5: Szukanie przecięcia 3x = e^x ---")
    
    # 1. Definicja funkcji f(x) = 3x - e^x
    f(x) = 3.0 * x - exp(x)
    a
    # 2. Parametry
    delta = 1e-4
    epsilon = 1e-4
    
    # 3. Ustalenie przedziałów (Analiza wstępna)
    # Funkcja ma dwa zera. Jedno blisko 0, drugie blisko 1.5.
    # f(0) = -1, f(1) = 3 - 2.71 = 0.29 (Zmiana znaku w [0, 1])
    # f(1) = 0.29, f(2) = 6 - 7.38 = -1.38 (Zmiana znaku w [1, 2])
    
    intervals = [(-100.0, 100.0), (0.0, 1.0), (1.0, 2.0)]  
    
    for (a, b) in intervals
        println("\nSzukanie w przedziale [$a, $b]:")
        (r, v, it, err) = mbisekcji(f, a, b, delta, epsilon)
        
        if err == 0
            @printf "   Pierwiastek r = %.8f\n" r
            @printf "   Wartość f(r)  = %.8e\n" v
            println("   Liczba iteracji: $it")
        else
            println("   Błąd: Funkcja nie zmienia znaku w zadanym przedziale.")
        end
    end
    println("="^50)
end

main()