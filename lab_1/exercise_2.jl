#=
Autor: Marcel Musiałek
Indeks: 279704
Zadanie 2: Obliczanie macheps metodą Kahana

Ten skrypt weryfikuje formułę Williama Kahana
do obliczania epsilona maszynowego: 3 * (4/3 - 1) - 1.
=#

using Printf

"""
    kahan_macheps(T::Type{<:AbstractFloat})

Oblicza epsilon maszynowy używając formuły Kahana.

Parametry formalne:
- `T`: Typ zmiennoprzecinkowy (np. Float16, Float32, Float64).

Zwraca:
- Wynik formuły Kahana w arytmetyce typu T.
"""
function kahan_macheps(T::Type{<:AbstractFloat})
    # Definiujemy stałe *wewnątrz* arytmetyki typu T
    # Wymusza to obliczenia w docelowej precyzji
    three::T = T(3.0)
    four::T = T(4.0)
    one::T = T(1.0)
    
    # Krok 1: Oblicz 4/3 (kluczowe zaokrąglenie)
    # Zmienna przechowująca wynik fl(4/3)
    four_thirds::T = four / three
    
    # Krok 2: Oblicz (4/3 - 1)
    # Zmienna przechowująca wynik fl(fl(4/3) - 1)
    one_third_approx::T = four_thirds - one
    
    # Krok 3: Oblicz 3 * (4/3 - 1)
    # Zmienna przechowująca wynik fl(3 * fl(...))
    one_approx::T = three * one_third_approx
    
    # Krok 4: Oblicz 3 * (4/3 - 1) - 1 (izolacja błędu)
    # Zmienna przechowująca ostateczny wynik
    result::T = one_approx - one
    
    return result
end

"""
    main()

Główna funkcja skryptu. Uruchamia test formuły Kahana
dla wszystkich typów i drukuje wyniki.
"""
function main()
    # Lista typów do przetestowania
    types_to_test = [Float16, Float32, Float64]
    
    println("--- Zadanie 2: Sprawdzanie formuły Kahana dla macheps ---")

    for T in types_to_test
        # Obliczenie wartości z formuły
        kahan_val = kahan_macheps(T)
        
        # Pobranie wbudowanej (oczekiwanej) wartości macheps
        built_in_eps = eps(T) # eps(T) w Julii to eps(T(1.0))
        
        @printf "\n--- Typ: %s ---\n" T
        @printf "Wynik z formuły Kahana: \t%.10e\n" kahan_val
        @printf "Wbudowane (eps(T)): \t\t%.10e\n" built_in_eps
        
        # Logika sprawdzająca zgodność (co do wartości i znaku)
        @printf "Czy równe eps(T)? \t\t%s\n" kahan_val == built_in_eps
        @printf "Czy równe -eps(T)? \t\t%s\n" kahan_val == -built_in_eps
    end
    println("\n--- Koniec Zadania 2 ---")
end

# Uruchomienie głównej funkcji
main()