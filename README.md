# Aplikacja Kulinarna (Flutter)

Projekt zrealizowany w ramach laboratoriów. Aplikacja umożliwia przeglądanie kategorii potraw, wyświetlanie listy dań dla wybranej kategorii. Aplikacja 
umożliwa również prace w trybie offline.

## Funkcjonalności
- **Pobieranie danych:** Pobieranie kategorii oraz dań z zewnętrznego API.
- **Cache offline:** Wykorzystanie bazy danych Hive do przechowywania danych, co pozwala na korzystanie z aplikacji przy braku połączenia.
- **Obsługa błędów:** Mechanizm try-catch z automatycznym przełączaniem na dane z pamięci podręcznej w przypadku awarii sieci.
- **Nawigacja:** Przejrzysta struktura między ekranami (kategorie -> lista dań).

## Uruchomienie
git clone https://github.com/AdamZarebski/meal_flutter_proj/ -> flutter pub get -> flutter run
