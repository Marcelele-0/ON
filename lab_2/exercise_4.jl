#=
Autor: Marcel Musiałek
Indeks: 279704
Zadanie 4 (Lista 2): Złośliwy wielomian Wilkinsona

Ten skrypt bada, jak katastrofalnie źle uwarunkowane jest
zadanie znajdowania pierwiastków wielomianu P(x) = (x-1)...(x-20)
podanego w postaci naturalnej (rozwiniętej).
=#

using Printf
using LinearAlgebra # Dla norm

# --- Instalacja i ładowanie pakietów ---
try
    using Polynomials
catch
    import Pkg
    Pkg.add("Polynomials")
    using Polynomials
end

"""
    p_stable(x)

Oblicza wielomian Wilkinsona p(x) = (x-1)(x-2)...(x-20)
w jego stabilnej numerycznie, iloczynowej formie.
"""
function p_stable(x::Number)::Float64
    return prod(Float64(x - i) for i in 1:20)
end

"""
    main()

Główna funkcja skryptu.
"""
function main()
    println("--- Zadanie 4 (Lista 2): Złośliwy wielomian Wilkinsona ---")
    println("Używamy precyzji: Float64")

    # --- Część (a): Postać naturalna ---
    println("\n" * "="^60)
    println("--- Część (a): Wielomian Wilkinsona w postaci naturalnej ---")

    # Generujemy wielomian P(x) = (x-1)...(x-20) w postaci iloczynowej
    
    # Funkcja collect() tworzy Wektor z Zakresu.
    P_natural = fromroots(collect(1:20)) 
    println("Wielomian Wilkinsona w postaci naturalnej:")

    # Znajdowanie pierwiastków
    println("Obliczanie pierwiastków z postaci naturalnej...")
    zk_complex = roots(P_natural)

    # Pierwiastki mogą mieć śladowe części urojone z powodu błędów num.
    zk = sort(real(zk_complex))

    println("\nPorównanie pierwiastków dokładnych (k) z obliczonymi (zk):")
    println("k \t zk (obliczony) \t |zk - k| (Błąd pierwiastka) \t |P(zk)| (Test P) \t |p(zk)| (Test p)")
    println("-"^90)

    for k in 1:20
        z = zk[k]
        err_root = abs(z - k)
        
        # Obliczamy |P(zk)| - wartość wielomianu naturalnego w obliczonym pierwiastku
        err_P = abs(P_natural(z))
        
        # Obliczamy |p(zk)| - wartość wielomianu stabilnego w obliczonym pierwiastku
        err_p = abs(p_stable(z))
        
        @printf "%d \t %.15e \t %.3e \t\t\t %.3e \t %.3e\n" k z err_root err_P err_p
    end

    # --- Część (b): Wielomian zaburzony ---
    println("\n" * "="^60)
    println("--- Część (b): Wielomian z zaburzonym współczynnikiem ---")
    
    # Kopiujemy współczynniki i konwertujemy na Float64, by dodać zaburzenie
    coeffs_float = convert(Vector{Float64}, P_natural.coeffs)
    
    # Współczynnik przy x^19 (indeks 20) to -210
    old_coeff = coeffs_float[20]
    
    # Zaburzenie (perturbacja)
    perturbation = 2.0^(-23) # To jest eps(Float32)
    coeffs_float[20] -= perturbation
    
    @printf "Zmieniono współczynnik x^19 z %.1f na %.17f\n" old_coeff coeffs_float[20]

    # Tworzymy nowy wielomian z zaburzonych współczynników
    P_mod = Polynomial(coeffs_float)
    
    println("Obliczanie pierwiastków z postaci zaburzonej...")
    zk_mod_complex = roots(P_mod)
    zk_mod = sort(real(zk_mod_complex))

    println("\nNowe, zaburzone pierwiastki (zk_mod):")
    println("k \t zk_mod (obliczony) \t |zk_mod - k| (Błąd pierwiastka) \t |P(zk_mod)| \t |p(zk_mod)|")
    println("-"^90)

    for k in 1:20
        z = zk_mod[k]
        err_root = abs(z - k)
        err_P = abs(P_mod(z))     # Test, czy 'z' jest pierwiastkiem P_mod
        err_p = abs(p_stable(z))  # Test, jak daleko 'z' jest od bycia pierwiastkiem p
        
        @printf "%d \t %.15e \t %.3e \t\t\t %.3e \t %.3e\n" k z err_root err_P err_p
    end
    
    println("\n--- Koniec Zadania 4 (Lista 2) ---")
end

# Uruchomienie głównej funkcji
main()