# Toolbar CI Suche

Im OTRS Standard ist es nicht möglich über die Toolbar Config Items zu suchen. 
Diese Erweiterung erlaubt es in allen Config Item Klassen zu suchen, auf die man
berechtig ist. 
Dieser Erweiterung fügt ein Dropdown mit Config Item Klassen und ein Suchfeld in die Toolbar ein,
dass es ermöglicht nach dem Namen von Config Items zu suchen.

## Sysconfig Einstellungen
Die Erweiterung kann mit 3 Sysconfig Einstellungen konfiguriert werden:

### Znuny4OTRSCISearch::SearchParams###Prefix

Erlaubt es einen Prefix Parameter für die Suche zu definieren, der an jede Eingabe im Suchfeld vorangestellt wird.

### Znuny4OTRSCISearch::SearchParams###Suffix

Erlaubt es einen Suffix Parameter für die Suche zu definieren, der an jede Eingabe im Suchfeld angefügt wird.

### Znuny4OTRSCISearch::SearchParams###DefaultClassName

Erlaubt es eine Standard Klasse für die Suche zu definieren. 

Hinweis: CI Klassen Namen werden ggf. auch übersetzt!