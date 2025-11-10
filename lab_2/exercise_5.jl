#=
Autor: Marcel Musiałek
Indeks: 279704
Zadanie 5 (Lista 2): Model logistyczny i wrażliwość na warunki początkowe

Ten skrypt bada zachowanie mapy logistycznej p_{n+1} = p_n + r*p_n*(1-p_n)
i jej wrażliwość na precyzję (Float32 vs Float64) oraz na
niewielkie zaburzenia (obcięcie wyniku).
=#

using Printf

"""
    main()

Główna funkcja skryptu. Przeprowadza dwa eksperymenty.
"""
function main()
    println("--- Zadanie 5 (Lista 2): Model logistyczny ---")
    
    n_steps = 40 # 40 iteracji
    
    # --- Eksperyment 1: Float32 vs Float32 z zaburzeniem ---
    println("\n" * "="^60)
    println("--- Eksperyment 1: Float32 (Normalny vs Zaburzony) ---")
    println("Parametry: p0 = 0.01, r = 3.0, Precyzja = Float32")
    
    # Ustawienie parametrów w Float32
    T32 = Float32
    p0_f32 = T32(0.01)
    r_f32 = T32(3.0)
    one_f32 = T32(1.0)
    
    # --- Uruchomienie 1: Normalne 40 iteracji ---
    # Wektor p_normal_f32 przechowuje wyniki p[0], p[1], ..., p[40]
    p_normal_f32 = zeros(T32, n_steps + 1)
    p_normal_f32[1] = p0_f32 # p[0]
    
    for n in 1:n_steps
        # Pobranie poprzedniej wartości p_{n-1} (zapisanej w p[n])
        p_n_minus_1 = p_normal_f32[n]
        # Obliczenie p_n i zapisanie w p[n+1]
        p_normal_f32[n+1] = p_n_minus_1 + r_f32 * p_n_minus_1 * (one_f32 - p_n_minus_1)
    end

    # --- Uruchomienie 2: 40 iteracji z zaburzeniem po 10. kroku ---
    p_perturbed_f32 = zeros(T32, n_steps + 1)
    p_perturbed_f32[1] = p0_f32 # p[0]
    
    for n in 1:n_steps
        # Pobranie poprzedniej wartości p_{n-1}
        p_n_minus_1 = p_perturbed_f32[n]
        
        # Warunek zaburzenia
        # Po 10. iteracji (czyli n=10), wynik p[10] jest w p_perturbed_f32[11]
        # Mamy go obciąć *zanim* zostanie użyty do obliczenia p[11].
        if n == 11 
            # p_n_minus_1 (czyli p_perturbed_f32[11]) zawiera p[10]
            # Zgodnie z poleceniem, obcinamy ten wynik do 0.722
            p_n_minus_1 = T32(0.722)
            # Nadpisujemy historię, aby było widać w tabeli
            p_perturbed_f32[n] = p_n_minus_1 
        end
        
        # Obliczenie p_n i zapisanie w p[n+1]
        p_perturbed_f32[n+1] = p_n_minus_1 + r_f32 * p_n_minus_1 * (one_f32 - p_n_minus_1)
    end
    
    # Drukowanie porównania (Eksperyment 1)
    println("\nPorównanie wyników (Normalny vs Zaburzony):")
    println("n \t p_n (Normalny) \t p_n (Zaburzony) \t Różnica")
    println("-"^60)
    for n in 0:n_steps
        # Indeksy w Julii są od 1, więc iteracja n=0 to indeks 1
        idx = n + 1
        val_norm = p_normal_f32[idx]
        val_pert = p_perturbed_f32[idx]
        diff = abs(val_norm - val_pert)
        
        @printf "%d \t %.8e \t %.8e \t %.3e\n" n val_norm val_pert diff
        
        if n == 10
            # Wizualne zaznaczenie, gdzie wprowadzono zaburzenie
            @printf "10 \t %.8e \t %.8e (Obcięto!)\t %.3e\n" val_norm val_pert diff
        end
    end
    
    # --- Eksperyment 2: Float32 vs Float64 ---
    println("\n" * "="^60)
    println("--- Eksperyment 2: Float32 vs Float64 (Normalne iteracje) ---")
    
    # Uruchomienie 3: Float64
    T64 = Float64
    p0_f64 = T64(0.01)
    r_f64 = T64(3.0)
    one_f64 = T64(1.0)
    
    p_normal_f64 = zeros(T64, n_steps + 1)
    p_normal_f64[1] = p0_f64
    for n in 1:n_steps
        p_n_minus_1 = p_normal_f64[n]
        p_normal_f64[n+1] = p_n_minus_1 + r_f64 * p_n_minus_1 * (one_f64 - p_n_minus_1)
    end
    
    # Drukowanie porównania (Eksperyment 2)
    println("\nPorównanie precyzji (Float32 vs Float64):")
    println("n \t p_n (Float32) \t p_n (Float64) \t Różnica (abs)")
    println("-"^70)
    for n in 0:n_steps
        idx = n + 1
        val_f32 = p_normal_f32[idx]
        val_f64 = p_normal_f64[idx]
        # Obliczamy różnicę w wyższej precyzji, aby uniknąć błędów
        diff = abs(Float64(val_f32) - val_f64) 
        @printf "%d \t %.8e \t %.15e \t %.3e\n" n val_f32 val_f64 diff
    end
    
    println("\n--- Koniec Zadania 5 (Lista 2) ---")
end

# Uruchomienie głównej funkcji
main()