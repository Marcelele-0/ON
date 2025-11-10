#=
Autor: Marcel Musiałek
Indeks: 279704
Zadanie 2 (Lista 2): Badanie funkcji f(x) = e^x * ln(1 + e^-x)

Ten skrypt analizuje zachowanie funkcji f(x) dla x -> oo.
1. Oblicza analitycznie granicę.
2. Drukuje tabelę wartości (x, f(x)) do wykorzystania w programie
   do wizualizacji (np. Gnuplot, Python/Matplotlib, Excel).
=#

using Printf

"""
    f(x::Float64)

Oblicza f(x) = e^x * ln(1 + e^-x) w arytmetyce Float64.
Ta forma jest podatna na błędy dla dużych x.
"""
function f(x::Float64)::Float64
    # Krok 1: e^x
    exp_x = exp(x)
    
    # Krok 2: e^(-x)
    exp_neg_x = exp(-x)
    
    # Krok 3: 1 + e^(-x)
    one_plus_exp_neg_x = 1.0 + exp_neg_x
    
    # Krok 4: ln(1 + e^(-x))
    log_term = log(one_plus_exp_neg_x)
    
    # Krok 5: e^x * ln(...)
    result = exp_x * log_term
    return result
end

"""
    main()

Główna funkcja skryptu.
"""
function main()
    println("--- Zadanie 2 (Lista 2): Analiza f(x) = e^x * ln(1 + e^-x) ---")

    # --- 1. Obliczenia numeryczne (Eksperyment) ---
    println("\n--- Tabela wartości (dane do wykresu) ---")
    println("Poniższe wartości pokazują, co oblicza komputer w Float64.")
    
    println("\nk \t x \t\t f(x) = e^x * ln(1 + e^-x)")
    println("-"^70)

    # Pętla pokazująca stabilne wartości
    for k in 0:10
        x = Float64(k)
        val_f = f(x)
        @printf "%d \t %.1f \t\t %.17e\n" k x val_f
    end
    
    println("... (Wartości zbliżają się do 1.0) ...")

    # Pętla pokazująca moment "załamania"
    # W Float64, e^(-x) staje się zerem (underflow) w okolicach x > 745
    # Ale już e^(-x) dodane do 1.0 gubi precyzję znacznie wcześniej.
    
    for k in 30:45
        x = Float64(k)
        val_f = f(x)
        @printf "%d \t %.1f \t\t %.17e\n" k x val_f
    end

    x = 50.0
    @printf "%d \t %.1f \t\t %.17e\n" x x f(x)
end

# Uruchomienie głównej funkcji
main()