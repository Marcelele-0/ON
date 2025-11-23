#=
Autor: Marcel Musiałek
Indeks: 279704
Moduł: MiejscaZerowe
Opis: Implementacja metod iteracyjnych rozwiązywania równań nieliniowych f(x) = 0.
Zawiera metody: bisekcji, Newtona (stycznych) oraz siecznych.
=#

module MiejscaZerowe

# Eksportujemy funkcje, aby były widoczne na zewnątrz modułu
export mbisekcji, mstycznych, msiecznych

# --- ZADANIE 1: Metoda Bisekcji ---

"""
    mbisekcji(f, a::Float64, b::Float64, delta::Float64, epsilon::Float64)

Rozwiązuje równanie f(x) = 0 metodą bisekcji w przedziale [a, b].

Parametry:
- f: funkcja anonimowa
- a, b: końce przedziału
- delta, epsilon: dokładności (błędu x i błędu wartości f)

Wynik:
(r, v, it, err)
- r: przybliżenie pierwiastka
- v: wartość f(r)
- it: liczba iteracji
- err: kod błędu (0 - ok, 1 - funkcja nie zmienia znaku)
"""
function mbisekcji(f, a::Float64, b::Float64, delta::Float64, epsilon::Float64)
    fa = f(a)
    fb = f(b)
    
    # Sprawdzenie, czy funkcja zmienia znak na końcach przedziału
    if sign(fa) == sign(fb)
        return (0.0, 0.0, 0, 1) # Błąd: brak zmiany znaku
    end
    
    it = 0
    u = a
    w = b
    e = w - u # Długość przedziału
    
    while e > delta
        it += 1
        e = e / 2.0
        c = u + e    # Środek przedziału
        fc = f(c)
        
        # Warunek stopu ze względu na bliskość zera lub mały przedział
        if abs(e) < delta || abs(fc) < epsilon
            return (c, fc, it, 0)
        end
        
        # Wybór podprzedziału
        if sign(fc) != sign(fa)
            w = c
            fb = fc
        else
            u = c
            fa = fc
        end
    end
    
    # Zwracamy środek ostatniego przedziału
    c = u + e
    return (c, f(c), it, 0)
end

# --- ZADANIE 2: Metoda Newtona (Stycznych) ---

"""
    mstycznych(f, pf, x0::Float64, delta::Float64, epsilon::Float64, maxit::Int)

Rozwiązuje równanie f(x) = 0 metodą Newtona (stycznych).

Parametry:
- f: funkcja f(x)
- pf: pochodna f'(x)
- x0: przybliżenie początkowe
- delta, epsilon: dokładności
- maxit: maksymalna liczba iteracji

Wynik:
(r, v, it, err) - err: 0 (ok), 1 (maxit), 2 (pochodna bliska 0)
"""
function mstycznych(f, pf, x0::Float64, delta::Float64, epsilon::Float64, maxit::Int)
    v = f(x0)
    
    if abs(v) < epsilon
        return (x0, v, 0, 0) # x0 jest już pierwiastkiem
    end
    
    x_curr = x0
    
    for k in 1:maxit
        deriv = pf(x_curr)
        
        # Zabezpieczenie przed dzieleniem przez zero (pochodna bliska 0)
        if abs(deriv) < eps(Float64)
            return (x_curr, v, k, 2) # Błąd: pochodna bliska zeru
        end
        
        # Krok Newtona: x_{k+1} = x_k - f(x_k) / f'(x_k)
        x_next = x_curr - v / deriv
        v = f(x_next)
        
        # Warunki stopu
        if abs(x_next - x_curr) < delta || abs(v) < epsilon
            return (x_next, v, k, 0) # Sukces
        end
        
        x_curr = x_next
    end
    
    # Przekroczono limit iteracji
    return (x_curr, v, maxit, 1)
end

# --- ZADANIE 3: Metoda Siecznych ---

"""
    msiecznych(f, x0::Float64, x1::Float64, delta::Float64, epsilon::Float64, maxit::Int)

Rozwiązuje równanie f(x) = 0 metodą siecznych.

Parametry:
- f: funkcja f(x)
- x0, x1: dwa przybliżenia początkowe
- delta, epsilon: dokładności
- maxit: limit iteracji

Wynik:
(r, v, it, err) - err: 0 (ok), 1 (maxit)
"""
function msiecznych(f, x0::Float64, x1::Float64, delta::Float64, epsilon::Float64, maxit::Int)
    fa = f(x0)
    fb = f(x1)
    
    for k in 1:maxit
        # Sprawdzenie czy wartości funkcji są wystarczająco różne, by uniknąć dzielenia przez 0
        if abs(fa) > abs(fb)
            # Swap, aby fb było bliżej zera (opcjonalna optymalizacja)
            x0, x1 = x1, x0
            fa, fb = fb, fa
        end
        
        # Wzór siecznych: x_{k+1} = x1 - f(x1) * (x1 - x0) / (f(x1) - f(x0))
        # Zabezpieczenie przed dzieleniem przez zero, gdy fa ~= fb
        denominator = fb - fa
        if abs(denominator) < eps(Float64)
             # Jeśli mianownik jest bliski zeru, nie możemy kontynuować.
             # Zwracamy to co mamy jako najlepsze przybliżenie.
             return (x1, fb, k, 1) 
        end

        s = (x1 - x0) / denominator
        x1 = x0
        fb = fa
        x0 = x0 - fa * s
        fa = f(x0)
        
        # Warunki stopu
        if abs(x1 - x0) < delta || abs(fa) < epsilon
            return (x0, fa, k, 0)
        end
    end
    
    return (x0, fa, maxit, 1)
end

end # Koniec modułu