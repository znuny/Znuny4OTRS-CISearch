# Konfiguration

Die Erweiterung kann mit drei SysConfig Einstellungen konfiguriert werden:

### Znuny4OTRSCISearch::SearchParams###Prefix

Diese SysConfig ermöglicht es einen Prefix Parameter für die Suche zu definieren, der an jede Eingabe im Suchfeld vorangestellt wird.

### Znuny4OTRSCISearch::SearchParams###Suffix

Diese SysConfig ermöglicht es einen Suffix Parameter für die Suche zu definieren, der an jede Eingabe im Suchfeld angefügt wird.

### Znuny4OTRSCISearch::SearchParams###FallbackDefaultClassName

Diese Konfiguration definiert eine globale Standard-Klasse, welche für die CI-Suche genutzt wird, wenn kein andere Klasse bestimmt werden konnte.

Standardwert: Computer

### Znuny4OTRSCISearch::SearchParams###DefaultClassName

Diese Konfiguration definiert ein Mapping zwischen Rollen zu Klassen-Namen, welche für die CI-Suche als Standard-Klasse genutzt wird. Diese Konfiguration ist per default deaktiviert.

Hinweis: CI Klassen Namen werden ggf. auch übersetzt!

Hier ein Beispiel:

Rollen-Name  =>  Klassen-Name

computerrole => Computer

hardwarerole => Hardware

locationrole => Location

networkrole  => Network

softwarerole => Software