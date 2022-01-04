# Configuration

There are three SysConfig settings available:

### ZnunyCISearch::SearchParams###Prefix

This options defines an optional prefix which is used for every search.

### ZnunyCISearch::SearchParams###Suffix

This options defines an optional suffix which is used for every search.

### ZnunyCISearch::SearchParams###FallbackDefaultClassName

This options defines a global default class that will be used for the CI search if no other class can be determined.

default value: Computer

### ZnunyCISearch::SearchParams###DefaultClassName

Defines a default CI class to search in.

Hint: CI class names can be translated.

### ZnunyCISearch::SearchParams###DefaultClassName

This option defines a mapping of role to class name that is used as default class for the CI search.
This configuration is disabled by default.

Note: CI class names will be translated!

Example:

Role name  =>  Class name

computerrole => Computer

hardwarerole => Hardware

locationrole => Location

networkrole  => Network

softwarerole => Software
