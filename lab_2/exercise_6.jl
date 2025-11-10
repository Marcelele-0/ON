#=
Autor: Marcel Musiałek
Indeks: 279704
Zadanie 6 (Lista 2): Badanie równania rekurencyjnego x_{n+1} = x_n^2 + c

Ten skrypt bada zachowanie iteracji dla 7 różnych
par (c, x0) w arytmetyce Float64.
=#

using Printf

"""
    run_iteration(c::Float64, x0::Float64, n_steps::Int, experiment_label::String)

Wykonuje i drukuje n_steps iteracji wzoru x_{n+1} = x_n^2 + c.
"""
function run_iteration(c::Float64, x0::Float64, n_steps::Int, experiment_label::String)
    println("\n" * "="^60)
    println("--- Eksperyment $(experiment_label) ---")
    @printf "Parametry: c = %.1f, x0 = %.15e\n" c x0
    println("-"^60)
    println("n \t x_n")
    
    # Używamy Float64 dla wszystkich obliczeń
    x_current::Float64 = x0
    c_f64::Float64 = c
    
    @printf "0 \t %.15e\n" x_current
    
    for n in 1:n_steps
        # Zapisujemy poprzednią wartość
        x_prev = x_current
        
        # Obliczenie iteracji: x_n = (x_{n-1})^2 + c
        x_current = x_prev^2 + c_f64
        
        @printf "%d \t %.15e\n" n x_current
        
        # Warunek stopu dla dywergencji (przepełnienie)
        if isinf(x_current)
            println("... Przerwano: Ciąg dąży do nieskończoności (Overflow) ...")
            break
        end
        
        # Warunek stopu dla zbieżności (punkt stały)
        if x_current == x_prev
            println("... Przerwano: Ciąg zbiegł do punktu stałego ...")
            break
        end
    end
end

"""
    main()

Główna funkcja skryptu. Uruchamia 7 eksperymentów.
"""
function main()
    println("--- Zadanie 6 (Lista 2): Badanie iteracji x_{n+1} = x_n^2 + c ---")
    
    n_steps = 40
    T = Float64

    # 1. c = -2, x0 = 1
    run_iteration(T(-2.0), T(1.0), n_steps, "1: c = -2, x0 = 1")

    # 2. c = -2, x0 = 2
    run_iteration(T(-2.0), T(2.0), n_steps, "2: c = -2, x0 = 2")

    # 3. c = -2, x0 = 1.999... (14 dziewiątek, zgodnie z poleceniem)
    x0_3 = 1.99999999999999
    run_iteration(T(-2.0), T(x0_3), n_steps, "3: c = -2, x0 = 1.999...9")

    # 4. c = -1, x0 = 1
    run_iteration(T(-1.0), T(1.0), n_steps, "4: c = -1, x0 = 1")
    
    # 5. c = -1, x0 = -1
    run_iteration(T(-1.0), T(-1.0), n_steps, "5: c = -1, x0 = -1")
    
    # 6. c = -1, x0 = 0.75
    run_iteration(T(-1.0), T(0.75), n_steps, "6: c = -1, x0 = 0.75")
    
    # 7. c = -1, x0 = 0.25
    run_iteration(T(-1.0), T(0.25), n_steps, "7: c = -1, x0 = 0.25")
    
    println("\n--- Koniec Zadania 6 (Lista 2) ---")
end

# Uruchomienie głównej funkcji
main()