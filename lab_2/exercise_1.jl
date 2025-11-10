#=
Autor: Marcel Musiałek
Indeks: 279704
Zadanie 1 (Lista 2): Wrażliwość iloczynu skalarnego (Porównanie)

Ten skrypt oblicza iloczyn skalarny S = sum(x[i] * y[i])
dla DANYCH ORYGINALNYCH (Lab 1, Zad 5) oraz DANYCH ZMODYFIKOWANYCH (Lab 2, Zad 1),
aby bezpośrednio porównać wpływ niewielkich zmian danych na wynik.
=#

using Printf

# --- Definicje algorytmów (a, b, c, d) ---
# (Te funkcje są identyczne jak w Lab 1, Zad 5)

function alg_a_forward(terms::Vector{T}) where T<:AbstractFloat
    S::T = T(0.0)
    for i in 1:length(terms); S = S + terms[i]; end
    return S
end

function alg_b_backward(terms::Vector{T}) where T<:AbstractFloat
    S::T = T(0.0)
    for i in length(terms):-1:1; S = S + terms[i]; end
    return S
end

function alg_c_largest_to_smallest(terms::Vector{T}) where T<:AbstractFloat
    pos_terms = filter(t -> t >= 0, terms)
    neg_terms = filter(t -> t < 0, terms)
    sort!(pos_terms, rev=true)
    sort!(neg_terms, rev=false)
    sum_pos::T = T(0.0); for t in pos_terms; sum_pos += t; end
    sum_neg::T = T(0.0); for t in neg_terms; sum_neg += t; end
    return sum_pos + sum_neg
end

function alg_d_smallest_to_largest(terms::Vector{T}) where T<:AbstractFloat
    pos_terms = filter(t -> t >= 0, terms)
    neg_terms = filter(t -> t < 0, terms)
    sort!(pos_terms, rev=false)
    sort!(neg_terms, rev=true)
    sum_pos::T = T(0.0); for t in pos_terms; sum_pos += t; end
    sum_neg::T = T(0.0); for t in neg_terms; sum_neg += t; end
    return sum_pos + sum_neg
end

# --- Funkcja pomocnicza do drukowania ---
"""
    run_and_print_comparison(T::Type{<:AbstractFloat}, x_data, y_data, correct_val)

Pomocnicza funkcja wykonująca obliczenia dla danego typu T i drukująca wyniki.
"""
function run_and_print_comparison(T::Type{<:AbstractFloat}, x_data, y_data, correct_val)
    println("\n" * "="^40)
    println("--- Obliczenia dla typu: $T ---")
    println("="^40)
    
    # Konwersja danych
    x = T.(x_data)
    y = T.(y_data)
    
    # Obliczenie iloczynów
    terms = x .* y
    
    println("Wektor obliczonych iloczynów (terms = x[i] * y[i]):")
    for (i, t) in enumerate(terms)
        @printf "terms[%d] = %+.15e\n" i t
    end
    
    # Obliczenie wyników dla 4 metod
    val_a = alg_a_forward(terms)
    val_b = alg_b_backward(terms)
    val_c = alg_c_largest_to_smallest(terms)
    val_d = alg_d_smallest_to_largest(terms)
    
    # Prezentacja wyników
    println("\n--- Wyniki sumowania dla $T ---")
    println("Metoda \t\t Wynik Obliczony \t\t Błąd Względny (vs ref)")
    println("-"^70)
    
    # Błąd względny jest zawsze liczony względem "prawdziwej" starej sumy
    rel_err(val) = abs(val - correct_val) / abs(correct_val)
    
    @printf "(a) W przód \t %.15e \t %.3e\n" val_a rel_err(val_a)
    @printf "(b) W tył \t %.15e \t %.3e\n" val_b rel_err(val_b)
    @printf "(c) Najw.->Najm. \t %.15e \t %.3e\n" val_c rel_err(val_c)
    @printf "(d) Najm.->Najw. \t %.15e \t %.3e\n" val_d rel_err(val_d)
end


"""
    main()

Główna funkcja skryptu. Porównuje wyniki dla starych i nowych danych.
"""
function main()
    println("--- Zadanie 1 (Lista 2): Porównanie wpływu błędów danych ---")

    # --- Definicje Danych ---
    
    # Dane wejściowe z Zadania 5 (Lista 1)
    x_data_old = [2.718281828, -3.141592654, 1.414213562, 0.5772156649, 0.3010299957]
    y_data = [1486.2497, 878366.9879, -22.37492, 4773714.647, 0.000185049]
    
    # NOWE Dane wejściowe (Zadanie 1, Lista 2)
    # x[4] ma usuniętą ostatnią '9'
    # x[5] ma usuniętą ostatnią '7'
    x_data_new = [2.718281828, -3.141592654, 1.414213562, 0.577215664, 0.301029995]
    
    # Prawidłowa wartość odniesienia (obliczona dla starych danych)
    correct_val_old = -1.00657107000000e-11

    # --- Wykonanie obliczeń ---
    
    run_and_print_comparison(Float32, x_data_old, y_data, correct_val_old)
    run_and_print_comparison(Float64, x_data_old, y_data, correct_val_old)

    println("\n\n")
    println("### 2. OBLICZENIA DLA NOWYCH DANYCH (LAB 2, ZAD 1) ###")

    # To pokaże, jak bardzo NOWY wynik ODBIEGA od STAREGO.
    run_and_print_comparison(Float32, x_data_new, y_data, correct_val_old)
    run_and_print_comparison(Float64, x_data_new, y_data, correct_val_old)

    println("\n" * "="^40)
    @printf "Wartość referencyjna (ze starych danych): \t %.15e\n" correct_val_old
end

main()