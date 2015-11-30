# Toolbar CI Suche

Im OTRS Standard ist es nicht möglich über die Toolbar Config Items zu suchen. Diese Erweiterung erlaubt es in allen Config Item Klassen zu suchen, für die man berechtig ist.
Dafür wird ein Dropdown Feld mit Config Item Klassen und ein Suchfeld für den Namen des Config Items zur Toolbar hinzugefügt. Dieses ist in allen Ansichten des AgentenInterface sichtbar.

## SysConfig Einstellungen

Die Erweiterung kann mit drei SysConfig Einstellungen konfiguriert werden:

### Znuny4OTRSCISearch::SearchParams###Prefix

Diese SysConfig ermöglicht es einen Prefix Parameter für die Suche zu definieren, der an jede Eingabe im Suchfeld vorangestellt wird.

### Znuny4OTRSCISearch::SearchParams###Suffix

Diese SysConfig ermöglicht es einen Suffix Parameter für die Suche zu definieren, der an jede Eingabe im Suchfeld angefügt wird.

### Znuny4OTRSCISearch::SearchParams###DefaultClassName

Diese SysConfig ermöglicht es eine Standard Klasse für die Suche zu definieren.

Hinweis: CI Klassen Namen werden ggf. auch übersetzt!
