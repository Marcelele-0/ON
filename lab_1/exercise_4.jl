#=
Autor: Marcel Musiałek
Indeks: 279704
Zadanie 4: Badanie tożsamości x * (1/x) = 1 (Wersja eksperymentalna)

Ten skrypt znajduje eksperymentalnie (brute-force) najmniejszą
liczbę zmiennopozycyjną x w przedziale (1, 2) w arytmetyce Float64,
dla której fl(x * fl(1/x)) != 1.
=#

using Printf

"""
    main()

Główna funkcja skryptu. Przeszukuje liczby maszynowe
począwszy od 1.0, aż znajdzie pierwszą, która nie spełnia
tożsamości x * (1/x) = 1.
"""
function main()
    println("--- Zadanie 4(a) i 4(b): Szukanie x w (1, 2) takiego, że x * (1/x) != 1 ---")

    # Definiujemy stałe dla Float64
    one_f64 = 1.0
    two_f64 = 2.0

    # Zaczynamy od 1.0
    x = one_f64
    
    # Zmienne do przechowania ostatniego "dobrego" stanu
    prev_x::Float64 = x
    prev_inv_x::Float64 = 0.0
    prev_val::Float64 = 0.0

    # Ustawiamy wystarczająco duży limit (wynik jest przy k ~ 257M)
    max_iterations = 300_000_000 
    
    # Zmienne na przechowanie wyniku
    found::Bool = false
    result_x::Float64 = 0.0
    result_val::Float64 = 0.0
    k_count::Int = 0 # Licznik kroków (k) od 1.0

    println("Rozpoczynam poszukiwania (limit = $max_iterations iteracji)...")

    for i in 1:max_iterations
        prev_x = x
        x = nextfloat(x)
        
        if x >= two_f64
            println("Przeszukano cały przedział [1, 2) i nie znaleziono błędu.")
            break
        end
        
        # Wykonujemy operacje w arytmetyce Float64
        inv_x = one_f64 / x
        val = x * inv_x
        
        k_count = i
        
        if val == one_f64
            prev_inv_x = inv_x
            prev_val = val
        end
        
        if val != one_f64
            found = true
            result_x = x
            result_val = val
            break 
        end
        
        # Licznik postępu
        if i % 100_000_000 == 0
            println("... Przekroczono $i iteracji, nadal szukam...")
        end
    end

    println("\n--- Wyniki ---")
    if found
        println("Znaleziono najmniejszą liczbę x spełniającą warunek (odp. na 4b):")
        
        println("\n--- Ostatnia 'poprawna' iteracja (k-1) ---")
        @printf "x_(k-1) = \t\t%.17e\n" prev_x
        println("Bitstring x_(k-1): \t", bitstring(prev_x))
        @printf "fl(1/x_(k-1)) = \t\t%.17e\n" prev_inv_x
        @printf "fl(x * fl(1/x)) = \t%.17e\n" prev_val
        println("Bitstring wyniku: \t", bitstring(prev_val))


        println("\n--- Pierwsza 'błędna' iteracja (k) ---")
        @printf "x_k = \t\t\t%.17e\n" result_x
        println("Bitstring x_k: \t\t", bitstring(result_x))
        @printf "Liczba k (x = 1.0 + k*eps(1.0)): %d\n" k_count
        
        println("\nSprawdzenie obliczenia dla x_k:")
        @printf "fl(1/x_k) = \t\t%.17e\n" (one_f64 / result_x)
        @printf "fl(x_k * fl(1/x_k)) = \t%.17e\n" result_val
        println("Bitstring wyniku: \t", bitstring(result_val))
        @printf "Wynik != 1.0: \t\t%s\n" (result_val != one_f64)
    else
        println("Nie znaleziono takiej liczby w przeszukanym zakresie (limit = $max_iterations).")
    end
    
    println("\n--- Koniec Zadania 4 ---")
end

# Uruchomienie głównej funkcji
main()