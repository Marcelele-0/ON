#=
Autor: Marcel Musiałek
Indeks: 279704
Zadanie 3 (Lista 2): Uwarunkowanie układów równań liniowych

intrsrukcja instalacji pakietu MatrixDepot:
    import Pkg; Pkg.add("MatrixDepot")

1. Eliminacja Gaussa (A \ b) - metoda stabilna
2. Mnożenie przez odwrotność (inv(A) * b) - metoda niestabilna
=#

using Printf
# Ta linia zainstaluje pakiet, jeśli go nie ma
try
    using MatrixDepot
catch
    import Pkg
    Pkg.add("MatrixDepot")
    using MatrixDepot
end
using LinearAlgebra # Dla A \ b, inv(), cond(), rank(), norm(), ones()


"""
    run_experiment(A::Matrix{Float64}, x_exact::Vector{Float64})

Funkcja pomocnicza do rozwiązywania układu Ax=b dwiema metodami
i obliczania błędów względnych.
"""
function run_experiment(A::Matrix{Float64}, x_exact::Vector{Float64})
    # Obliczenie wektora b na podstawie znanego x
    b = A * x_exact
    
    # Metoda 1: Eliminacja Gaussa (stabilna)
    x_gauss = A \ b
    
    # Metoda 2: Mnożenie przez odwrotność (niestabilna)
    x_inv = similar(x_gauss) # Stwórz wektor o tym samym typie
    try
        x_inv = inv(A) * b
    catch e
        if e isa SingularException
            # Jeśli macierz jest osobliwa, wypełnij wynik NaN
            fill!(x_inv, NaN) 
        else
            rethrow(e)
        end
    end

    # Obliczenie błędów względnych (norma 2)
    norm_x = norm(x_exact) # Norma x_exact to sqrt(n)
    err_gauss = norm(x_gauss - x_exact) / norm_x
    err_inv = norm(x_inv - x_exact) / norm_x
    
    return err_gauss, err_inv
end

"""
    main()

Główna funkcja skryptu.
"""
function main()
    T = Float64
    println("Używamy precyzji: $T")

    # --- Część (a): Macierz Hilberta ---
    println("\n" * "="^60)
    println("--- Część (a): Macierz Hilberta H(n) ---")
    println("n \t Wskaźnik uwar. cond(A) \t Błąd (A \\ b) \t Błąd (inv(A) * b)")
    println("-"^60)

    # Sprawdzamy n od 2 do 15.
    for n in 2:15
        A = Matrix{T}(matrixdepot("hilb", n))
        x_exact = ones(T, n)
        
        cond_A = cond(A)
        
        err_gauss, err_inv = run_experiment(A, x_exact)
        
        @printf "%d \t %.8e \t\t %.3e \t %.3e\n" n cond_A err_gauss err_inv
    end

    # --- Część (b): Macierz losowa R(n, c) ---
    println("\n" * "="^60)
    println("--- Część (b): Macierz losowa matcond(n, c) ---")
    println("n \t Cel 'c' \t Zmierzone cond(A) \t Błąd (A \\ b) \t Błąd (inv(A) * b)")
    println("-"^60)

    ns_to_test = [5, 10, 20]
    cs_to_test = [1.0, 10.0, 1e3, 1e7, 1e12, 1e16]

    for n in ns_to_test
        x_exact = ones(T, n)
        for c in cs_to_test
            # Generujemy macierz o zadanym uwarunkowaniu 'c'
            # Używamy "randsvd" z MatrixDepot, co odpowiada matcond
            A = Matrix{T}(matrixdepot("randsvd", n, c))
            
            # Mierzymy *faktyczne* uwarunkowanie wygenerowanej macierzy
            cond_A = cond(A)
            
            err_gauss, err_inv = run_experiment(A, x_exact)
            
            @printf "%d \t %.1e \t %.8e \t\t %.3e \t %.3e\n" n c cond_A err_gauss err_inv
        end
    end
end

# Uruchomienie głównej funkcji
main()