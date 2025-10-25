#=
Autor: Marcel Musiałek
Indeks: 279704
Zadanie 5: Obliczanie iloczynu skalarnego różnymi metodami

Ten skrypt oblicza iloczyn skalarny S = sum(x[i] * y[i])
używając czterech różnych algorytmów sumowania (a, b, c, d),
aby pokazać wpływ kolejności operacji na błędy zaokrągleń.
Obliczenia są wykonywane dla Float32 i Float64.
=#

using Printf

# --- Definicje algorytmów ---

"""
    alg_a_forward(terms::Vector{T}) where T<:AbstractFloat

Oblicza sumę wektora 'terms' w kolejności "w przód" (i=1 do n).
"""
function alg_a_forward(terms::Vector{T}) where T<:AbstractFloat
    S::T = T(0.0)
    # Pętla od i = 1 do n (w tym przypadku n=5)
    for i in 1:length(terms)
        S = S + terms[i]
    end
    return S
end

"""
    alg_b_backward(terms::Vector{T}) where T<:AbstractFloat

Oblicza sumę wektora 'terms' w kolejności "w tył" (i=n do 1).
"""
function alg_b_backward(terms::Vector{T}) where T<:AbstractFloat
    S::T = T(0.0)
    # Pętla od i = n do 1 (w tym przypadku n=5)
    for i in length(terms):-1:1
        S = S + terms[i]
    end
    return S
end

"""
    alg_c_largest_to_smallest(terms::Vector{T}) where T<:AbstractFloat

Oblicza sumę 'terms' metodą (c):
1. Sumuje dodatnie wyrazy od największego do najmniejszego.
2. Sumuje ujemne wyrazy od najmniejszego (najbardziej ujemnego) do największego.
3. Dodaje obie sumy częściowe.
"""
function alg_c_largest_to_smallest(terms::Vector{T}) where T<:AbstractFloat
    # Podział na wektory dodatnie i ujemne
    pos_terms = filter(t -> t >= 0, terms)
    neg_terms = filter(t -> t < 0, terms)
    
    # Sortowanie (c)
    # Dodatnie: od największego do najmniejszego (malejąco)
    sort!(pos_terms, rev=true)
    # Ujemne: od najmniejszego do największego (rosnąco)
    sort!(neg_terms, rev=false)
    
    # Obliczenie sum częściowych
    # sum() w Julii jest zoptymalizowane, ale tu użyjemy prostej pętli
    # dla spójności z duchem zadania (kolejność ma znaczenie)
    
    sum_pos::T = T(0.0)
    for t in pos_terms
        sum_pos += t
    end
    
    sum_neg::T = T(0.0)
    for t in neg_terms
        sum_neg += t
    end
    
    # Zwrócenie sumy końcowej
    return sum_pos + sum_neg
end

"""
    alg_d_smallest_to_largest(terms::Vector{T}) where T<:AbstractFloat

Oblicza sumę 'terms' metodą (d) (przeciwną do (c)):
1. Sumuje dodatnie wyrazy od najmniejszego do największego.
2. Sumuje ujemne wyrazy od największego (najmniej ujemnego) do najmniejszego.
3. Dodaje obie sumy częściowe.
"""
function alg_d_smallest_to_largest(terms::Vector{T}) where T<:AbstractFloat
    # Podział na wektory dodatnie i ujemne
    pos_terms = filter(t -> t >= 0, terms)
    neg_terms = filter(t -> t < 0, terms)
    
    # Sortowanie (d)
    # Dodatnie: od najmniejszego do największego (rosnąco)
    sort!(pos_terms, rev=false)
    # Ujemne: od największego do najmniejszego (malejąco)
    sort!(neg_terms, rev=true)
    
    # Obliczenie sum częściowych
    sum_pos::T = T(0.0)
    for t in pos_terms
        sum_pos += t
    end
    
    sum_neg::T = T(0.0)
    for t in neg_terms
        sum_neg += t
    end
    
    # Zwrócenie sumy końcowej
    return sum_pos + sum_neg
end


"""
    main()

Główna funkcja skryptu. Definiuje dane, uruchamia
algorytmy dla Float32 i Float64, drukuje wyniki.
"""
function main()
    println("--- Zadanie 5: Błędy sumowania iloczynu skalarnego ---")

    # Dane wejściowe z zadania (zdefiniowane w Float64 dla maksymalnej precyzji)
    x_data = [2.718281828, -3.141592654, 1.414213562, 0.5772156649, 0.3010299957]
    y_data = [1486.2497, 878366.9879, -22.37492, 4773714.647, 0.000185049]
    
    # Prawidłowa wartość odniesienia
    correct_val = -1.00657107000000e-11

    # Pętla po obu wymaganych precyzjach
    for T in [Float32, Float64]
        println("\n" * "="^40)
        println("--- Obliczenia dla typu: $T ---")
        println("="^40)
        
        # Konwersja danych wejściowych do badanej precyzji
        x = T.(x_data)
        y = T.(y_data)
        
        # Krok 1: Obliczenie wektora iloczynów x[i] * y[i]
        # Ta operacja również podlega zaokrągleniom do typu T
        terms = x .* y
        
        println("Wektor obliczonych iloczynów (terms = x[i] * y[i]):")
        for (i, t) in enumerate(terms)
            @printf "terms[%d] = %+.15e\n" i t
        end
        
        # Obliczenie wyników dla wszystkich 4 metod
        val_a = alg_a_forward(terms)
        val_b = alg_b_backward(terms)
        val_c = alg_c_largest_to_smallest(terms)
        val_d = alg_d_smallest_to_largest(terms)
        
        # Prezentacja wyników
        println("\n--- Wyniki sumowania dla $T ---")
        println("Metoda \t\t Wynik Obliczony \t\t Błąd Względny")
        println("-"^60)
        
        # Funkcja pomocnicza do obliczania błędu względnego
        rel_err(val) = abs(val - correct_val) / abs(correct_val)
        
        @printf "(a) W przód \t %.15e \t %.3e\n" val_a rel_err(val_a)
        @printf "(b) W tył \t %.15e \t %.3e\n" val_b rel_err(val_b)
        @printf "(c) Najw.->Najm. \t %.15e \t %.3e\n" val_c rel_err(val_c)
        @printf "(d) Najm.->Najw. \t %.15e \t %.3e\n" val_d rel_err(val_d)
    end
    
    println("\n" * "="^40)
    @printf "Wartość referencyjna: \t %.15e\n" correct_val
    println("--- Koniec Zadania 5 ---")
end

# Uruchomienie głównej funkcji
main()