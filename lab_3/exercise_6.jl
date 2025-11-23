#=
Autor: Marcel Musiałek
Indeks: 279704
Zadanie 6 (Lista 3): Porównanie metod dla f1(x) = e^(1-x)-1 i f2(x) = x*e^-x
=#

include("MiejscaZerowe.jl")
using .MiejscaZerowe
using Printf

function run_tests(f, pf, label_f, a, b, x0_newton, x0_sec, x1_sec, delta, epsilon, maxit)
    println("\nAnaliza funkcji $label_f")
    println("-"^60)
    
    # 1. Bisekcja
    (r, v, it, err) = mbisekcji(f, a, b, delta, epsilon)
    @printf "Bisekcja [%.1f, %.1f]: \t r=%.6f, it=%d, err=%d\n" a b r it err

    # 2. Newton
    (r, v, it, err) = mstycznych(f, pf, x0_newton, delta, epsilon, maxit)
    @printf "Newton (x0=%.1f): \t\t r=%.6f, it=%d, err=%d\n" x0_newton r it err

    # 3. Sieczne
    (r, v, it, err) = msiecznych(f, x0_sec, x1_sec, delta, epsilon, maxit)
    @printf "Sieczne (x0=%.1f, x1=%.1f): \t r=%.6f, it=%d, err=%d\n" x0_sec x1_sec r it err
end

function main()
    println("--- Zadanie 6: Porównanie metod iteracyjnych ---")
    delta = 1e-5
    epsilon = 1e-5
    maxit = 100

    # --- Funkcja f1(x) = e^(1-x) - 1 ---
    # Pierwiastek to x=1.
    f1(x) = exp(1.0 - x) - 1.0
    pf1(x) = -exp(1.0 - x) # Pochodna
    
    # Przedział dla bisekcji [0, 2] (zawiera 1)
    # Newton startujemy blisko, ale też sprawdzimy "trudne" przypadki
    run_tests(f1, pf1, "f1(x) = e^(1-x) - 1", 0.0, 2.0, 2.0, 0.0, 2.0, delta, epsilon, maxit)
    
    # TEST SPECJALNY DLA NEWTONA (f1)
    # Polecenie: sprawdzić x0 > 1 (np. 10, 100)
    println("\nTesty specjalne Newtona dla f1 (x0 > 1):")
    for x0 in [5.0, 10.0, 100.0]
        (r, v, it, err) = mstycznych(f1, pf1, x0, delta, epsilon, maxit)
        @printf "x0 = %.1f -> r=%.6f, it=%d, v=%.1e\n" x0 r it v
    end


    # --- Funkcja f2(x) = x * e^(-x) ---
    # Pierwiastek to x=0.
    f2(x) = x * exp(-x)
    pf2(x) = exp(-x) - x * exp(-x) # Pochodna: e^-x * (1 - x)
    
    # Przedział dla bisekcji [-0.5, 0.5] (zawiera 0)
    run_tests(f2, pf2, "f2(x) = x * e^(-x)", -0.5, 0.5, -0.5, -0.5, 0.5, delta, epsilon, maxit)

    # TEST SPECJALNY DLA NEWTONA (f2)
    # Polecenie: sprawdzić x0 > 1. Pochodna zeruje się w x=1!
    println("\nTesty specjalne Newtona dla f2 (szukanie zera w x=0):")
    
    # Przypadek A: x0 bliskie 1 (pochodna bliska 0)
    x0_crit = 1.0
    (r, v, it, err) = mstycznych(f2, pf2, x0_crit, delta, epsilon, maxit)
    println("x0 = 1.0 (ekstremum!): err kod = $err (oczekiwany błąd pochodnej)")

    # Przypadek B: x0 > 1 (za górką)
    # Tutaj styczna ucieka w prawo, w stronę +nieskończoności, nigdy nie trafiając w zero
    for x0 in [1.5, 2.0, 10.0]
        (r, v, it, err) = mstycznych(f2, pf2, x0, delta, epsilon, maxit)
        @printf "x0 = %.1f -> r=%.6f, it=%d (czy zbiegła do 0?)\n" x0 r it
    end

    println("="^60)
end

main()