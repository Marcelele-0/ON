#=
Autor: Marcel Musiałek
Indeks: 279704
Zadanie 7: Błąd aproksymacji pochodnej

Ten skrypt oblicza przybliżoną wartość pochodnej funkcji
f(x) = sin(x) + cos(3x) w punkcie x0 = 1 za pomocą wzoru
różnicy skończonej w przód: (f(x0 + h) - f(x0)) / h.
Badany jest wpływ kroku h = 2^(-n) na błąd aproksymacji
w arytmetyce Float64.
=#

using Printf

"""
    f(x::Float64)

Oblicza wartość funkcji sin(x) + cos(3x).
"""
function f(x::Float64)::Float64
    return sin(x) + cos(3.0 * x)
end

"""
    f_prime_exact(x::Float64)

Oblicza dokładną wartość pochodnej funkcji f(x),
tj. cos(x) - 3*sin(3x).
"""
function f_prime_exact(x::Float64)::Float64
    return cos(x) - 3.0 * sin(3.0 * x)
end

"""
    main()

Główna funkcja skryptu. Iteruje przez n = 0..54,
oblicza h = 2^(-n), przybliżoną pochodną, błąd,
oraz wartość 1 + h, i drukuje wyniki.
"""
function main()
    println("--- Zadanie 7: Błąd aproksymacji pochodnej f(x) = sin(x) + cos(3x) w x0 = 1 ---")
    println("--- Obliczenia w Float64 ---")

    # Punkt, w którym liczymy pochodną
    x0::Float64 = 1.0
    # Dokładna wartość pochodnej w x0
    f_prime_x0::Float64 = f_prime_exact(x0)

    println("\nPunkt x0 = ", x0)
    @printf "Dokładna pochodna f'(x0) = %.17e\n" f_prime_x0

    println("\nn \t h = 2^(-n) \t\t f_approx'(x0) \t\t |f'(x0) - f_approx'(x0)| \t 1.0 + h (w Float64)")
    println("-"^110)

    # Wartość f(x0) obliczona raz
    f_x0 = f(x0)

    # Zakres n zgodnie z poleceniem
    n_max = 54

    for n in 0:n_max
        # Obliczenie kroku h
        h::Float64 = 2.0^(-n)

        # Sprawdzenie, jak zachowuje się 1.0 + h w arytmetyce Float64
        one_plus_h = 1.0 + h

        # Obliczenie x0 + h
        x0_plus_h = x0 + h

        # Obliczenie przybliżonej pochodnej
        f_approx::Float64 = 0.0
        
        # Zabezpieczenie przed dzieleniem przez zero lub gdy x0 + h == x0
        # (co prowadzi do błędnego wyniku 0)
        if x0_plus_h == x0 || h == 0.0
            # Jeśli h jest tak małe, że x0+h zaokrągla się do x0,
            # licznik staje się f(x0)-f(x0)=0. Wynik aproksymacji to 0.
            f_approx = 0.0
            # Alternatywnie, moglibyśmy zgłosić błąd lub NaN,
            # ale dla celów demonstracji błędu, 0 jest bardziej czytelne.
        else
            f_x0_plus_h = f(x0_plus_h)
            f_approx = (f_x0_plus_h - f_x0) / h
        end

        # Obliczenie błędu bezwzględnego
        abs_err = abs(f_prime_x0 - f_approx)

        # Drukowanie wyników
        # Zwróć uwagę na format %.17e dla 1.0 + h, aby zobaczyć precyzję
        @printf "%d \t %.8e \t %.17e \t %.8e \t\t %.17e\n" n h f_approx abs_err one_plus_h
    end

    println("\n--- Koniec Zadania 7 ---")
end

# Uruchomienie głównej funkcji
main()