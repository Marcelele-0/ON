#=
Autor: Marcel Musiałek
Indeks: 279704
Zadanie 6: Porównanie stabilności numerycznej f(x) i g(x)

Ten skrypt oblicza wartości dwóch matematycznie równoważnych funkcji:
f(x) = sqrt(x^2 + 1) - 1
g(x) = x^2 / (sqrt(x^2 + 1) + 1)
dla malejących wartości x = 8^(-k), aby pokazać wpływ
błędów zaokrągleń (katastrofalnej anulacji) na wynik f(x).
Obliczenia wykonywane są w arytmetyce Float64.
=#

using Printf

"""
    f(x::Float64)

Oblicza sqrt(x^2 + 1) - 1. Ta forma jest podatna na
katastrofalną anulację dla małych x.
"""
function f(x::Float64)::Float64
    # Obliczenie sqrt(x^2 + 1)
    sqrt_term = sqrt(x^2 + 1.0)
    # Odejmujemy 1.0 - tutaj występuje anulacja dla małych x
    result = sqrt_term - 1.0
    return result
end

"""
    g(x::Float64)

Oblicza x^2 / (sqrt(x^2 + 1) + 1). Ta forma jest
numerycznie stabilna dla małych x.
"""
function g(x::Float64)::Float64
    # Obliczenie sqrt(x^2 + 1)
    sqrt_term = sqrt(x^2 + 1.0)
    # Obliczamy mianownik (dodawanie, stabilne)
    denominator = sqrt_term + 1.0
    # Obliczamy licznik
    numerator = x^2
    # Dzielenie (stabilne)
    result = numerator / denominator
    return result
end

"""
    main()

Główna funkcja skryptu. Iteruje przez x = 8^(-k),
oblicza f(x) i g(x), i drukuje wyniki.
"""
function main()
    println("--- Zadanie 6: Porównanie f(x) = sqrt(x^2+1)-1 i g(x) = x^2/(sqrt(x^2+1)+1) ---")
    println("--- Obliczenia w Float64 ---")
    
    # Maksymalna potęga do przetestowania
    max_k = 15 
    
    println("\nk \t x = 8^(-k) \t\t f(x) \t\t\t g(x)")
    println("-"^80)
    
    for k in 1:max_k
        # Obliczenie argumentu x
        x::Float64 = 8.0^(-k)
        
        # Obliczenie wartości obu funkcji
        val_f = f(x)
        val_g = g(x)
        
        # Wypisanie wyników
        @printf "%d \t %.8e \t %.17e \t %.17e\n" k x val_f val_g
        
        # Warunek przerwania: jeśli f(x) staje się zero lub g(x) jest subnormalne
        # (co sugeruje, że dalsze obliczenia mogą być niedokładne)
        if val_f == 0.0 || val_g < floatmin(Float64)
            println("\nPrzerywam: f(x) stało się zerem lub g(x) osiągnęło limit precyzji.")
            break
        end
    end
    
    println("\n--- Koniec Zadania 6 ---")
end

# Uruchomienie głównej funkcji
main()