#=
Autor: Marcel Musiałek
Indeks: 279704
Zadanie 3: Rozmieszczenie liczb zmiennoprzecinkowych

Ten skrypt eksperymentalnie sprawdza, jak liczby Float64
są rozmieszczone w przedziałach [1, 2], [0.5, 1] oraz [2, 4].
=#

using Printf

"""
    format_bitstring(f64::Float64)

Pomocnicza funkcja do formatowania bitstring dla Float64
na części: Znak (1), Wykładnik (11), Mantysa (52).

Parametry formalne:
- `f64`: Liczba typu Float64.

Zwraca:
- Sformatowany łańcuch znaków.
"""
function format_bitstring(f64::Float64)
    # Pobranie 64-bitowego stringa
    s = bitstring(f64)
    
    # Podział na S EEEEEEEEEEE FFFFF...
    znak = s[1:1]
    wykladnik = s[2:12]
    mantysa = s[13:end]
    
    return "$znak $wykladnik $mantysa"
end

"""
    main()

Główna funkcja skryptu. Uruchamia wszystkie części zadania
i drukuje wyniki w terminalu.
"""
function main()
    println("--- Zadanie 3: Rozmieszczenie liczb zmiennoprzecinkowych ---")

    # --- Część 3.1: Badanie przedziału [1.0, 2.0] ---
    println("\n--- Część 3.1: Badanie przedziału [1.0, 2.0] ---")

    # Definiujemy teoretyczną deltę dla [1, 2]
    delta_teor = 2.0^(-52)
    @printf "Teoretyczna delta (2^-52): \t%.17e\n" delta_teor
    
    # eps(1.0) to jest dokładnie macheps, czyli delta dla przedziału [1, 2]
    @printf "Wartość eps(1.0): \t\t%.17e\n" eps(1.0)

    # Badamy liczbę 1.0 (k=0)
    x1 = 1.0
    println("\nLiczba x1 = 1.0 (k=0)")
    println("Bitstring x1: \t", format_bitstring(x1))

    # Badamy następną liczbę (k=1)
    x2_nextfloat = nextfloat(x1)
    x2_teoria = 1.0 + delta_teor

    println("\nLiczba x2 (następna po 1.0, k=1)")
    println("Bitstring x2 (z nextfloat): \t", format_bitstring(x2_nextfloat))
    println("Bitstring x2 (z 1.0 + delta): \t", format_bitstring(x2_teoria))
    @printf "Wartość x2 (z nextfloat): \t%.17e\n" x2_nextfloat
    println("Czy (1.0 + 2^-52) == nextfloat(1.0)? \t", x2_teoria == x2_nextfloat)

    # Badamy kolejną liczbę (k=2)
    x3_nextfloat = nextfloat(x2_nextfloat)
    x3_teoria = 1.0 + 2 * delta_teor
    
    println("\nLiczba x3 (k=2)")
    println("Bitstring x3 (z nextfloat): \t", format_bitstring(x3_nextfloat))
    println("Bitstring x3 (z 1.0 + 2*delta): \t", format_bitstring(x3_teoria))
    println("Czy (1.0 + 2*2^-52) == nextfloat(nextfloat(1.0))? \t", x3_teoria == x3_nextfloat)

    # --- Część 3.2: Badanie przedziałów [2.0, 4.0] i [0.5, 1.0] ---
    println("\n--- Część 3.2: Badanie przedziałów [2.0, 4.0] i [0.5, 1.0] ---")

    # --- Przedział [2.0, 4.0] ---
    println("\n--- Przedział [2.0, 4.0] ---")
    y1 = 2.0
    y2_nextfloat = nextfloat(y1)
    # Obliczamy deltę empirycznie
    delta_y = y2_nextfloat - y1

    println("Liczba y1 = 2.0")
    println("Bitstring y1: \t", format_bitstring(y1))
    println("\nLiczba y2 (następna po 2.0)")
    println("Bitstring y2: \t", format_bitstring(y2_nextfloat))

    @printf "\nObliczony krok delta_y = y2-y1: \t%.17e\n" delta_y
    @printf "Wartość eps(2.0): \t\t%.17e\n" eps(2.0)
    @printf "Czy delta_y == 2^-51? \t\t%s\n" delta_y == 2.0^(-51)

    # --- Przedział [0.5, 1.0] ---
    println("\n--- Przedział [0.5, 1.0] ---")
    z1 = 0.5
    z2_nextfloat = nextfloat(z1)
    # Obliczamy deltę empirycznie
    delta_z = z2_nextfloat - z1

    println("Liczba z1 = 0.5")
    println("Bitstring z1: \t", format_bitstring(z1))
    println("\nLiczba z2 (następna po 0.5)")
    println("Bitstring z2: \t", format_bitstring(z2_nextfloat))

    @printf "\nObliczony krok delta_z = z2-z1: \t%.17e\n" delta_z
    @printf "Wartość eps(0.5): \t\t%.17e\n" eps(0.5)
    @printf "Czy delta_z == 2^-53? \t\t%s\n" delta_z == 2.0^(-53)
end

# Uruchomienie głównej funkcji
main()