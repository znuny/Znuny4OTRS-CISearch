# Konfiguration

Die Erweiterung kann mit drei SysConfig-Einstellungen konfiguriert werden:

### ZnunyCISearch::SearchParams###Prefix

Diese Optiom ermöglicht es, einen Präfix-Parameter für die Suche zu definieren, der an jede Eingabe im Suchfeld vorangestellt wird.

### ZnunyCISearch::SearchParams###Suffix

Diese Option ermöglicht es, einen Suffix-Parameter für die Suche zu definieren, der an jede Eingabe im Suchfeld angefügt wird.

### ZnunyCISearch::SearchParams###FallbackDefaultClassName

Diese Option definiert eine globale Standard-Klasse, welche für die CI-Suche genutzt wird, wenn kein andere Klasse bestimmt werden konnte.

Standardwert: Computer

### ZnunyCISearch::SearchParams###DefaultClassName

Diese Option definiert ein Mapping zwischen Rollen- und Klassennamen, welche für die CI-Suche als Standard-Klasse genutzt wird. Diese Konfiguration ist per Default deaktiviert.

Hinweis: CI-Klassennamen werden ggf. auch übersetzt!

Beispiele:

Rollenname  =>  Klassenname

computerrole => Computer

hardwarerole => Hardware

locationrole => Location

networkrole  => Network

softwarerole => Software
