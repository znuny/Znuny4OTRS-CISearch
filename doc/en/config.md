# Configuration

There are three SysConfig settings available:

### Znuny4OTRSCISearch::SearchParams###Prefix

This SysConfig defines an optional prefix which is used for every search.

### Znuny4OTRSCISearch::SearchParams###Suffix

This SysConfig defines an optional suffix which is used for every search.

### Znuny4OTRSCISearch::SearchParams###FallbackDefaultClassName

This configuration defines a global default class that will be used for the CI search if no other class can not get determined.

default value: Computer

### Znuny4OTRSCISearch::SearchParams###DefaultClassName

Defines a default CI class where to search.

Hint: CI class names can be translated by OTRS!

### Znuny4OTRSCISearch::SearchParams###DefaultClassName

This configuration defines a mapping of role to class name that is used as default class for the CI search.
This configuration is disabled by default.

Note: CI Class names will be also translated!

Here's an example:

Role-Name  =>  Class-Name

computerrole => Computer

hardwarerole => Hardware

locationrole => Location

networkrole  => Network

softwarerole => Software
