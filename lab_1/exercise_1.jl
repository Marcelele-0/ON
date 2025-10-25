#=
Autor: Marcel Musiałek
Indeks: 279704
Zadanie 1: Rozpoznanie arytmetyki zmiennoprzecinkowej

Ten skrypt implementuje funkcje do iteracyjnego wyznaczania
charakterystycznych wartości arytmetyki IEEE 754 (macheps, eta, MAX)
dla typów Float16, Float32 i Float64.
=#

using Printf

# --- Część 1: Epsilon Maszynowy (macheps) ---

"""
    find_macheps(T::Type{<:AbstractFloat})

Oblicza iteracyjnie epsilon maszynowy (macheps) dla typu T.

Parametry formalne:
- `T`: Typ zmiennoprzecinkowy (np. Float16, Float32, Float64).

Zwraca:
- Wartość macheps dla typu T.
"""
function find_macheps(T::Type{<:AbstractFloat})
    # Definicje stałych w arytmetyce typu T
    one::T = T(1.0)
    two::T = T(2.0)
    
    # Inicjalizacja macheps
    macheps::T = one

    # Pętla dzieli macheps przez 2, dopóki (1.0 + macheps/2.0) > 1.0
    while (one + (macheps / two)) > one
        macheps = macheps / two
    end
    
    return macheps
end

# --- Część 2: Najmniejsza liczba dodatnia (eta / MIN_sub) ---

"""
    find_eta(T::Type{<:AbstractFloat})

Oblicza iteracyjnie najmniejszą dodatnią liczbę subnormalną (eta) dla typu T.

Parametry formalne:
- `T`: Typ zmiennoprzecinkowy.

Zwraca:
- Wartość eta (MIN_sub) dla typu T.
"""
function find_eta(T::Type{<:AbstractFloat})
    # Definicje stałych w arytmetyce typu T
    one::T = T(1.0)
    two::T = T(2.0)
    zero::T = T(0.0)
    
    # Inicjalizacja eta
    eta::T = one

    # Pętla dzieli eta przez 2, dopóki (eta / 2) jest nadal większe od 0
    while (eta / two) > zero
        eta = eta / two
    end
    
    return eta
end

# --- Część 4: Największa liczba skończona (MAX) ---

"""
    find_max(T::Type{<:AbstractFloat})

Oblicza iteracyjnie największą skończoną liczbę (MAX) dla typu T.

Parametry formalne:
- `T`: Typ zmiennoprzecinkowy.

Zwraca:
- Wartość MAX (floatmax) dla typu T.
"""
function find_max(T::Type{<:AbstractFloat})
    # Definicje stałych w arytmetyce typu T
    one::T = T(1.0)
    two::T = T(2.0)

    # Wymagane jest macheps z Części 1
    macheps = find_macheps(T) 

    # Krok 1: Znajdź największą potęgę dwójki (2^E_max)
    max_power_of_2 = one
    while !isinf(max_power_of_2 * two)
        max_power_of_2 = max_power_of_2 * two
    end
    
    # Krok 2: Oblicz MAX ze wzoru MAX = 2^E_max * (2.0 - macheps)
    iterative_max = max_power_of_2 * (two - macheps)
    
    return iterative_max
end

# --- Główna funkcja wykonawcza ---

"""
    main()

Główna funkcja skryptu. Uruchamia wszystkie części zadania
i drukuje wyniki w terminalu.
"""
function main()
    # Lista typów do przetestowania
    types_to_test = [Float16, Float32, Float64]

    println("--- Zadanie 1: Rozpoznanie arytmetyki ---")

    # --- Wywołanie Części 1 ---
    println("\n--- Część 1: Wyznaczanie Epsilona Maszynowego (macheps) ---")
    for T in types_to_test
        @printf "--- Typ: %s ---\n" T
        @printf "Iteracyjnie: \t\t%.10e\n" find_macheps(T)
        @printf "Wbudowane (eps(T)): \t%.10e\n" eps(T)
    end

    # --- Wywołanie Części 2 ---
    println("\n--- Część 2: Wyznaczanie Najmniejszej Liczby Dodatniej (eta / MIN_sub) ---")
    for T in types_to_test
        @printf "--- Typ: %s ---\n" T
        @printf "Iteracyjnie: \t\t\t%.10e\n" find_eta(T)
        @printf "Wbudowane (nextfloat(0.0)): \t%.10e\n" nextfloat(T(0.0))
    end

    # --- Wywołanie Części 3 ---
    println("\n--- Część 3: Badanie floatmin(T) vs eta ---")
    @printf "floatmin(Float16): \t%.10e (vs eta: %.10e)\n" floatmin(Float16) find_eta(Float16)
    @printf "floatmin(Float32): \t%.10e (vs eta: %.10e)\n" floatmin(Float32) find_eta(Float32)
    @printf "floatmin(Float64): \t%.10e (vs eta: %.10e)\n" floatmin(Float64) find_eta(Float64)

    # --- Wywołanie Części 4 ---
    println("\n--- Część 4: Wyznaczanie Największej Liczby Skończonej (MAX) ---")
    for T in types_to_test
        @printf "--- Typ: %s ---\n" T
        @printf "Iteracyjnie: \t\t%.10e\n" find_max(T)
        @printf "Wbudowane (floatmax): \t%.10e\n" floatmax(T)
    end
    println("\n--- Koniec Zadania 1 ---")
end

# Uruchomienie głównej funkcji
main()