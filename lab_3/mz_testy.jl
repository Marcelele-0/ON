#=
Autor: Marcel Musiałek
Indeks: 279704
Prosty test poprawności zaimplementowanych metod.
Funkcja testowa: f(x) = x^2 - 4. Miejsce zerowe: x = 2.0.
=#

include("MiejscaZerowe.jl")
using .MiejscaZerowe

function run_simple_tests()
    println("--- WERYFIKACJA NA FUNKCJI f(x) = x^2 - 4 ---")
    
    f(x) = x^2 - 4.0
    pf(x) = 2.0 * x # Pochodna dla Newtona
    
    delta = 1e-6
    epsilon = 1e-6
    maxit = 20

    # 1. Bisekcja (przedział [1, 3])
    res_bis = mbisekcji(f, 1.0, 3.0, delta, epsilon)
    println("Bisekcja [1.0, 3.0]:     ", res_bis)

    # 2. Newton (start z 3.0)
    res_newt = mstycznych(f, pf, 3.0, delta, epsilon, maxit)
    println("Newton (x0=3.0):         ", res_newt)

    # 3. Sieczne (start z 1.0 i 3.0)
    res_sec = msiecznych(f, 1.0, 3.0, delta, epsilon, maxit)
    println("Sieczne (x0=1.0, x1=3.0):", res_sec)
end

run_simple_tests()