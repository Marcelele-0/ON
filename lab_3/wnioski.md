# sprawozdanie draft
## Zadania 1 - 3

### opis zadań 
zaimpletowanie metod biscekcji newtona i siecznych zgodnie z pseudokodem z wykładu
sprawdzienie porpawności impletacji przy użyciu prostych funkcji

### opis rozwiązania
Poza implementacją dodano proste testy dal funckji f(x) = X^2 - 4 

### wynik

--- WERYFIKACJA NA FUNKCJI f(x) = x^2 - 4 ---
Bisekcja [1.0, 3.0]:     (2.0, 0.0, 1, 0)
Newton (x0=3.0):         (2.000000000026214, 1.0485656787295738e-10, 4, 0)
Sieczne (x0=1.0, x1=3.0):(2.000000195092221, 7.803689223706556e-7, 5, 0)

# wnioski
funckje i ich imneptacja działają porpawnie dla prostych danych 


## Zadanie 4

### Opis zadania 
Celem zadania było wyznaczenie pierwiastka równania f(X) przy użyciu trzech zaimplementowanych metod iteracyjnych:
- Metody bisekcji
- Metody Newtona 
- Metody siecznych

### Opis rozwiązania 
Wykorzystano moduł miejsca zerowe zawierający implementacje metod.
Zdefiniowano funkcję f(x) oraz jej pochodną f'(x). Dla każdej metody wywołano odpowiednią funkcję z zadanymi parametrami i zmierzono liczbę iteracji oraz końcowy błąd f(r).

### wynik
    Wymagana dokładność: delta = 5.0e-6, epsilon = 5.0e-6

    1. Metoda Bisekcji (przedział [1.5, 2.0]):
    Pierwiastek r = 1.933753967285156
    Wartość f(r)  = -2.702768013840284e-07
    Iteracje      = 16
    ------------------------------------------------------------
    2. Metoda Newtona (x0 = 1.5):
    Pierwiastek r = 1.933753779789742
    Wartość f(r)  = -2.242331631485683e-08
    Iteracje      = 4
    ------------------------------------------------------------
    3. Metoda Siecznych (x0 = 1.0, x1 = 2.0):
    Pierwiastek r = 1.933753644474301
    Wartość f(r)  = 1.564525129449379e-07
    Iteracje      = 4
    ============================================================

### obserwacje 
    - bardzo podobne miesjca zerowe
    - wieksza ilsoc iteracji w metodzie bisekcji
    - różne znaki f(r)

### wnioski 
    ten eskperyment potwierdza teoretyczne właściwosci badanych metod
    - Metoda Bisekcji - Jest zdeycdowanie najwolniejsza, posaida zbiezronsoc liniową
    - Metoda Newtowna - Ma teortyecznie najlepszą zbieżńosc (kwadratową) - w ekepcytmencie rwoniez daje najelpsze wyniki 
    - Metoda Siecznych - Usykała równie dobre wyniki co metoda newtona mimo toerytcznie gorszej zbieżnosci 
    eskperyment ten ukazuje że na określonym wąskim przedzaiale lepiej sprawdzają sie metody newtona i siecznych 
    Pokazuje to dlaczego mtoedy hybrydwowe są skuteczne 



## Zadanie 5

### Opis zadania 
Zadanie polegało na znalezieniu wartości x, dla których przecinają się wykresy funkcji y = 3x oraz y = e^x.

### Opis rozwiązania 
Sprawdzenie szerokiego zakresu dla metody bisekcji [-100, 100] - szansa ze algorytm i tak znajdzie rozwiązanie  
Zauważyć można że f(0) = -1, f(1) < 0, f(2) > 0 co ozancza że w przedziałach [0, 1] i [1, 2] zanjdują się miesca zerowe.
Zaimplementowano skrypt wykorzystujący funkcję mbisekcji z modułu {MiejscaZerowe}, uruchamiając ją niezależnie dla obu wyznaczonych wyżej przedziałów.

### wynik
Szukanie w przedziale [-100.0, 100.0]:
   Błąd: Funkcja nie zmienia znaku w zadanym przedziale.

Szukanie w przedziale [0.0, 1.0]:
   Pierwiastek r = 0.61914062
   Wartość f(r)  = 9.06632034e-05
   Liczba iteracji: 9

Szukanie w przedziale [1.0, 2.0]:
   Pierwiastek r = 1.51208496
   Wartość f(r)  = 7.61857860e-05
   Liczba iteracji: 13=====================


### obserwacje
    - w szeorkim zakresie nie działa metoda - ustalono ze funckja ma 2 pierwiaski wiec na końcahc szerokiego zakresu znak będzie taki sam 
    - w obu przybliżonych przypadadkach pierwiastek funckji został znaleziony z rozsądną ilocią iteracji 

### wnioski 
    - metoda bisekcji wymaga zmiany znaku na danym zakresie więc w przypadku wystąpienia na nim parzystej ilości pierwiasktów metoda może zawieść
    - na przedziałach gdzie zmiana znaku występuje raz metoda bisekcji gwarantuje zanlezienie pierwiastka 



## Zadanie 6

## opis zadania
Zadanie polegało na znalezieniu miejsc zerowych dwóch zadanich funckji 
Celem było przetestowanie metod Bisekcji, Newtona i Siecznych dla standardowych przedziałów, a następnie zbadanie zachowania Metody Newtona dla "trudnych" punktów startowych, gdzie pochodna jest bliska zeru lub zmienia znak.

## opis rozwiązania 
Zaimplementowano funkcje f1, f2 oraz ich pochodne:
Dla f1 przeprowadzono testy stabilności Newtona dla dużych x_0, gdzie wykres funkcji staje się płaski (asymptota pozioma).
Dla f2 sprawdzono punkt x_0 = 1 (ekstremum lokalne) oraz punkty x_0 > 1, gdzie styczna kieruje iteracje w przeciwną stronę od pierwiastka.

### wynik
Analiza funkcji f1(x) = e^(1-x) - 1
------------------------------------------------------------
Bisekcja [0.0, 2.0]:     r=1.000000, it=1, err=0
Newton (x0=2.0):                 r=1.000000, it=5, err=0
Sieczne (x0=0.0, x1=2.0):        r=1.000002, it=6, err=0

Testy specjalne Newtona dla f1 (x0 > 1):
x0 = 5.0 -> r=1.000000, it=54, v=3.6e-07
x0 = 10.0 -> r=NaN, it=100, v=NaN
x0 = 100.0 -> r=100.000000, it=1, v=-1.0e+00

### obserwacje
    Metody zbiegły szybko. Bisekcja trafiła idealnie w 1 iteracji, ponieważ x=1 jest środkiem przedziału [0, 2].
    Dla x=5 pochodna jest bardzo mała (funkcja płaska). Metoda Newtona potrzebowała aż 54 iteracji, aby "wrócić" do pierwiastka.
    Dla bardzo dużych x, pochodna jest numerycznie zerowa. Metoda albo generuje błędy (`NaN`), albo stoi w miejscu, ponieważ styczna jest prawie równoległa do osi OX.

Analiza funkcji f2(x) = x * e^(-x)
------------------------------------------------------------
Bisekcja [-0.5, 0.5]:    r=0.000000, it=1, err=0
Newton (x0=-0.5):                r=-0.000000, it=4, err=0
Sieczne (x0=-0.5, x1=0.5):       r=0.000005, it=6, err=0

Testy specjalne Newtona dla f2 (szukanie zera w x=0):
x0 = 1.0 (ekstremum!): err kod = 2 (oczekiwany błąd pochodnej)
x0 = 1.5 -> r=14.787437, it=10 (czy zbiegła do 0?)
x0 = 2.0 -> r=14.398663, it=10 (czy zbiegła do 0?)
x0 = 10.0 -> r=14.380524, it=4 (czy zbiegła do 0?)

### obserwacje
    Funkcja ma maksimum w x=1. Pochodna wynosi 0. Metoda Newtona zwróciła błąd (dzielenie przez zero), co jest zachowaniem poprawnym.
    Dla x > 1 styczna do wykresu przecina oś OX po prawej stronie (w coraz większych wartościach x), oddalając się od pierwiastka $x=0$. Metoda rozbiega się do nieskończoności. Wartości typu `14.7` to moment, w którym algorytm się zatrzymał (przypadkowo spełniając warunek tolerancji dla bardzo małej wartości funkcji), ale nie jest to poszukiwany pierwiastek.


link do gemini: https://gemini.google.com/share/5c51d8c591d6