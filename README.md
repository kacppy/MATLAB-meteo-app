# [PL] MATLAB Meteo App 

Projekt zrobiony na zaliczenie 1 semestru z zajęć w Matlabie z użyciem modułu App Designer.

## 

Oprogramowanie korzysta ze zmodyfikowanej bazy danych
pochodzącej ze strony geonames.org. 

Baza jest aktualna na dzień 22.01.2022 i zawiera prawie wszystkie
miejscowości w Polsce, jest przechowywana w pliku "miasta.csv"
dołączonym wraz z programem. 

Dane pobierane są z wykorzystaniem API od OpenWeatherMap


## Skrócony opis działania

Po wczytaniu bazy przez program realizowane jest wyszukiwanie
miejscowości o podanej nazwie lub fragmencie nazwy, a użytkownik
może wybrać pasujący wynik z listy.

Aplikacja zawiera dwa kluczowe przyciski akcji: 
- pierwszy z nich otwiera okienko danymi na temat aktualnej pogody w wybranej miejscowości
- drugi przycisk natomiast otwiera okienko z wykresami i prognozowanymi danymi pogody na następne 5 dni. Przybliżając wykresy w osi X możemy uzyskać bardziej dokładne dane 
(dane wejściowe są z dokładnością do 3h, natomiast dzięki użyciu
odpowiednio spreparowanej funkcji „plot” dostępnej w ramach języka
Matlab możemy "przewidywać" wartości danych, przybliżając wykres w osi X). 

Wykresy zawierają następujące dane
pogodowe: temperatura, ciśnienie, wilgotność oraz
prawdopodobieństwo wystąpienia opadów. 


# Interfejs


![Main_Menu](https://i.imgur.com/MOauRve.png)

![Main_Menu](https://i.imgur.com/iiQoeu1.png)

![Main_Menu](https://i.imgur.com/2j9lGlM.png)


# Użytkowanie


Aby program zadziałał musimy posiadać klucz API do OpenWeatherMap, który umieszczamy w linii 17 edytora AppDesigner

![API_KEY](https://i.imgur.com/H9DyIqm.png)

# License

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)

